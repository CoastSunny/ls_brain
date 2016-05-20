/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package javagraphdraw;

import com.itextpdf.text.PageSize;
import com.itextpdf.text.Rectangle;
import java.awt.Color;
import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.lang.reflect.Field;
import javax.xml.xpath.*;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.ParserConfigurationException;
import org.openide.util.Exceptions;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;
import org.w3c.dom.Node;
import org.w3c.dom.Element;
import java.lang.Exception; 
import org.xml.sax.*;
import java.util.*; 
import java.util.concurrent.TimeUnit;
import org.gephi.graph.api.GraphController;
import org.gephi.graph.api.GraphModel;
import org.gephi.graph.api.Graph;
import org.gephi.io.exporter.api.ExportController;
import org.gephi.io.exporter.preview.PDFExporter;
import org.gephi.io.exporter.preview.PNGExporter;
import org.gephi.layout.plugin.AbstractLayout;
import org.gephi.layout.plugin.AutoLayout;
import org.gephi.layout.plugin.force.StepDisplacement;
import org.gephi.layout.plugin.force.yifanHu.YifanHuLayout;
import org.gephi.layout.plugin.forceAtlas2.ForceAtlas2;
import org.gephi.layout.plugin.forceAtlas2.ForceAtlas2Builder;
import org.gephi.layout.plugin.labelAdjust.LabelAdjust;
import org.gephi.layout.spi.Layout;
import org.gephi.preview.api.PreviewController;
import org.gephi.preview.api.PreviewModel;
import org.gephi.preview.api.PreviewProperty;
import org.gephi.project.api.ProjectController;
import org.gephi.project.api.Workspace;
import org.openide.util.Lookup;
/**
 *
 * @author Lev
 */
public class GraphLayout {
    protected class CEdge {
        public CEdge(int aFrom, int aTo, float aWeight)
        { From = aFrom; To = aTo; Weight = aWeight; }
        public int From;
        public int To;
        public float Weight; 
    }
    public class CNodeProperties {
        public CNodeProperties(int[] NodeIDs, float[] Color, float Size, float LabelSize)
        {
            m_NodeIDs = NodeIDs.clone();
            m_Color = Color.clone();
            m_Size = Size;
            m_LabelSize = LabelSize;
        }
        public int[] m_NodeIDs;
        public float[] m_Color;
        public float m_Size;
        public float m_LabelSize; 
    }
    public class CEdgeProperties {
        public CEdgeProperties(int[][] Edges, float[] Color, float Size)
        {
            m_Edges  =new int[2][];
            m_Edges[0] = Edges[0].clone();
            m_Edges[1] = Edges[1].clone();
            m_Color = Color.clone();
        }
        public int[][] m_Edges;
        public float[] m_Color;
        public float m_Size; // width
    }
    protected class CFrame {
        CFrame(int Index)
        { 
            m_Index = Index; 
            m_EdgesRemove = new int[2][];
            m_EdgesAdd = new int[2][];
        }
        boolean Load(Element FrameElement)
        {
            if (m_Index!=Integer.parseInt(FrameElement.getAttribute("Index"))) { return false; }
            m_FileName = FrameElement.getAttribute("FileName");
            NodeList FrameElements =FrameElement.getChildNodes(); 
            for (int i = 0; i < FrameElements.getLength(); ++i){
                 if (FrameElements.item(i).getNodeType() == Node.ELEMENT_NODE) {
                    Element CurrentElement = (Element)FrameElements.item(i);
                    if ("NodesAdd".equals(CurrentElement.getNodeName())){
                        int Count = Integer.parseInt(CurrentElement.getAttribute("Count"));
                        if (Count>0) { System.err.print("Frame.NodesAdd is not yet implemented. Ignoring");  Count = 0; }
                        m_NodesAdd = new int[Count];
                    }
                    else if ("NodesRemove".equals(CurrentElement.getNodeName())){
                       int Count = Integer.parseInt(CurrentElement.getAttribute("Count"));
                       if (Count>0) { System.err.print("Frame.m_NodesRemove is not yet implemented. Ignoring");  Count = 0; }
                       m_NodesRemove = new int[Count];
                    }
                    else if ("EdgesAdd".equals(CurrentElement.getNodeName())){
                        int Count = Integer.parseInt(CurrentElement.getAttribute("Count"));
                        if (Count>0) { System.err.print("Frame.m_EdgesAdd is not yet implemented. Ignoring");  Count = 0; }                        
                        m_EdgesAdd[0] = new int[Count];
                        m_EdgesAdd[1] = new int[Count];
                    }
                    else if ("EdgesRemove".equals(CurrentElement.getNodeName())){
                       int Count = Integer.parseInt(CurrentElement.getAttribute("Count"));
                       if (Count>0) { System.err.print("Frame.m_EdgesRemove is not yet implemented. Ignoring");  Count = 0; }                        
                        m_EdgesRemove[0] = new int[Count];
                        m_EdgesRemove[1] = new int[Count];
                    }
                    else if ("NodesProperties".equals(CurrentElement.getNodeName())){                        
                        m_NodeProperties = new ArrayList<CNodeProperties>();
                        NodeList NodePropertiesElements = CurrentElement.getChildNodes();
                        for (int j =0; j < NodePropertiesElements.getLength(); ++j) {
                            if ("NodesProperties".equals(NodePropertiesElements.item(j).getNodeName())) {
                                Element CurrentNodePropertiesElement = (Element)NodePropertiesElements.item(j);
                                String[] ColorStr = CurrentNodePropertiesElement.getAttribute("Color").split("  ");
                                float[] ColorAr = new float[3];
                                int S=0;
                                for (int k =0; k <ColorStr.length; ++k ) {
                                    if (ColorStr[k].trim().length()>0) {
                                        ColorAr[S++] = Float.parseFloat(ColorStr[k]);
                                    }
                                }
                                float Size = Float.parseFloat(CurrentNodePropertiesElement.getAttribute("Size"));
                                float LabelSize = Float.parseFloat(CurrentNodePropertiesElement.getAttribute("LabelSize"));
                                int[] NodeIDs;
                                if (Integer.parseInt(CurrentNodePropertiesElement.getAttribute("Count")) > 0) {
                                    String[] NodeIDsStr = CurrentNodePropertiesElement.getTextContent().split("\\D+");
                                    NodeIDs = new int[NodeIDsStr.length];
                                    for (int k =0; k <NodeIDsStr.length; ++k ) {
                                        NodeIDs[k] = Integer.parseInt(NodeIDsStr[k]);
                                    }
                                } else { NodeIDs = new int[0]; }
                                m_NodeProperties.add(new CNodeProperties(NodeIDs, ColorAr,  Size,LabelSize));
                            }
                        }
                    }
                    else if ("EdgesProperties".equals(CurrentElement.getNodeName())){
                        m_EdgeProperties = new ArrayList<CEdgeProperties>();
                        NodeList EdgesPropertiesElements = CurrentElement.getChildNodes();
                        for (int j =0; j < EdgesPropertiesElements.getLength(); ++j) {
                            if ("EdgesProperties".equals(EdgesPropertiesElements.item(j).getNodeName())) {
                                Element CurrentNodePropertiesElement = (Element)EdgesPropertiesElements.item(j);
                                String[] ColorStr = CurrentNodePropertiesElement.getAttribute("Color").split("  ");
                                float[] ColorAr = new float[3];
                                int S=0;
                                for (int k =0; k <ColorStr.length; ++k ) {
                                    if (ColorStr[k].trim().length()>0) {
                                        ColorAr[S++] = Float.parseFloat(ColorStr[k]);
                                    }
                                }                                
                                int[][] Edges = new int[2][];
                                if (Integer.parseInt(CurrentNodePropertiesElement.getAttribute("Count")) > 0) {
                                    String[] NodeIDsStr = CurrentNodePropertiesElement.getTextContent().split("\\D+");
                                    Edges[0] = new int[NodeIDsStr.length/2];
                                    Edges[1] = new int[NodeIDsStr.length/2];
                                    for (int k =0; k <NodeIDsStr.length/2; ++k ) {
                                        Edges[0][k] = Integer.parseInt(NodeIDsStr[k]);
                                        Edges[1][k] = Integer.parseInt(NodeIDsStr[k+NodeIDsStr.length/2]);
                                    }
                                } 
                                else { Edges[0] = new int[0]; Edges[1] = new int[0]; }
                                float EdgeSize = 1.0f;
                                if (CurrentNodePropertiesElement.hasAttribute("Size") && Float.parseFloat(CurrentNodePropertiesElement.getAttribute("Size")) >= 0) {
                                    EdgeSize = Float.parseFloat(CurrentNodePropertiesElement.getAttribute("Size"));
                                }                                 
                                m_EdgeProperties.add(new CEdgeProperties(Edges, ColorAr,EdgeSize));
                            }
                        }
                    }
                    else if ("Algorithm".equals(CurrentElement.getNodeName())){
                        m_Algorithm = new CAlgorithm();
                        if (!m_Algorithm.Load(CurrentElement)) { return false; }
                    }
                    else if ("Preview".equals(CurrentElement.getNodeName())){
                        m_Preview = new CPreview();
                        if (!m_Preview.Load(CurrentElement)) { return false; }
                    }
                 }                
            }
            return true; 
        }
        public int m_Index; 
        public String m_FileName; 
        public int[] m_NodesAdd; 
        public int[] m_NodesRemove; 
        public int[][] m_EdgesAdd; 
        public int[][] m_EdgesRemove; 
        public List<CNodeProperties> m_NodeProperties; 
        public List<CEdgeProperties> m_EdgeProperties; 
        public CAlgorithm m_Algorithm; 
        public CPreview m_Preview;
    }
    protected class CAlgorithm {
       public CAlgorithm()
       { 
           m_SettingNames = new ArrayList<String>();
           m_SettingValues = new ArrayList<String>();
       }
        boolean Load(Element AlgorithmElement)
        {
            if (AlgorithmElement==null || !"Algorithm".equals(AlgorithmElement.getNodeName())) { return false; }          
            m_AlgorithmName = AlgorithmElement.getAttribute("AlgorithmName");
            m_LayoutTimeOut = Math.round(Double.parseDouble(AlgorithmElement.getAttribute("LayoutTimeOut")));
            if (AlgorithmElement.getElementsByTagName("LabelAdjust").getLength()>0) {
                Element LabelAdjustElement = (Element)AlgorithmElement.getElementsByTagName("LabelAdjust").item(0);
                m_LabelAdjustTimeOut = Math.round(Double.parseDouble( LabelAdjustElement.getAttribute("LabelAdjustTimeOut")));
            }  else { m_LabelAdjustTimeOut = 0; }
            
            m_SettingNames.clear(); m_SettingValues.clear(); 
            NodeList SettingsElements = AlgorithmElement.getElementsByTagName("AlgorithmSetting");
            for (int i = 0; i < SettingsElements.getLength(); ++i) {
                if (SettingsElements.item(i).getNodeType() == Node.ELEMENT_NODE) {
                    Element CurrentElement = (Element)SettingsElements.item(i);
                    m_SettingNames.add(CurrentElement.getAttribute("Name"));
                    m_SettingValues.add(CurrentElement.getAttribute("Value"));
                }
            }
            return true; 
        }       
        public String m_AlgorithmName;
        public long m_LayoutTimeOut;
        public List<String> m_SettingNames; 
        public List<String> m_SettingValues;
        
        public long m_LabelAdjustTimeOut; 
   }
     protected class CPreview  {
       public CPreview()
       { 
           m_SettingNames = new ArrayList<String>();
           m_SettingValues = new ArrayList<String>();
       }
        boolean Load(Element PreviewElement)
        {
            m_SettingNames.clear(); m_SettingValues.clear();
            if (PreviewElement==null || !"Preview".equals(PreviewElement.getNodeName())) { return false; }
            
            NodeList SettingsElements = PreviewElement.getElementsByTagName("PreviewSetting");
            for (int i = 0; i < SettingsElements.getLength(); ++i) {
                if (SettingsElements.item(i).getNodeType() == Node.ELEMENT_NODE) {
                    Element CurrentElement = (Element)SettingsElements.item(i);
                    m_SettingNames.add(CurrentElement.getAttribute("Name"));
                    m_SettingValues.add(CurrentElement.getAttribute("Value"));
                }
            }
            return true; 
        }     
        public List<String> m_SettingNames; 
        public List<String> m_SettingValues;
        
    }
    protected class CExport {
       public CExport()
       { }
        boolean Load(Element GraphDrawElement)
        {
            if (GraphDrawElement==null) { return false; }
            if (((NodeList)GraphDrawElement.getElementsByTagName("Export")).getLength()!=1) { return false; }
            Element ExportElement  = (Element)((NodeList)GraphDrawElement.getElementsByTagName("Export")).item(0);
            if (((NodeList)ExportElement.getElementsByTagName("ExportFormat")).getLength()!=1) { return false;   }
            m_ExportFormat = ((NodeList)ExportElement.getElementsByTagName("ExportFormat")).item(0).getTextContent();
            return true; 
        }     
        public String m_ExportFormat;
    }
    
    public GraphLayout()
    {
        m_xpathFactory = XPathFactory.newInstance();
    }
    public boolean Load(String aFileName)// throws ParserConfigurationException
    {
        try // throws ParserConfigurationException
        {
              XPath xpath = m_xpathFactory.newXPath();
            
               m_XMLFile = new File(aFileName); 
               if (!m_XMLFile.exists()) { return false; }
               
               DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
               DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
               Document doc = dBuilder.parse(m_XMLFile);
               doc.getDocumentElement().normalize();              
            
               Element GraphDrawElement  = (Element)doc.getElementsByTagName("GraphDraw").item(0);
               m_IsDirected = Boolean.getBoolean(GraphDrawElement.getAttributes().getNamedItem("Directed").getTextContent());
               
              Element GraphElement = (Element)((NodeList)xpath.evaluate("Graph", GraphDrawElement,XPathConstants.NODESET)).item(0);
              if (!LoadGraph(GraphDrawElement)) { return false; }
              if (!LoadFrames(GraphDrawElement)) { return false; }
            //  if (!LoadAlgorithm(GraphDrawElement)) { return false; }
             // if (!LoadPreview(GraphDrawElement)) { return false; }
              if (!LoadExport(GraphDrawElement)) { return false; }
               return true; 
        } catch (XPathExpressionException ex) {
            Exceptions.printStackTrace(ex);
        } catch (ParserConfigurationException ex) {
            Exceptions.printStackTrace(ex);
        } catch (SAXException ex) {
            Exceptions.printStackTrace(ex);
        } catch (IOException ex) {
            Exceptions.printStackTrace(ex);
        }
        return false; 
    }
    /* protected boolean LoadPreview(Element GraphDrawElement)
    {
        m_Preview = new CPreview(); 
        return m_Preview.Load(GraphDrawElement);
    }*/
    protected boolean LoadExport(Element GraphDrawElement)
    {
        m_Export = new CExport(); 
        return m_Export.Load(GraphDrawElement);
    }
  /*  protected boolean LoadAlgorithm(Element GraphDrawElement)
    {
        m_Algorithm = new CAlgorithm();
        return m_Algorithm.Load(GraphDrawElement);
    }*/
    protected boolean LoadFrames(Element GraphDrawElement)
    {
        try {
            XPath xpath = m_xpathFactory.newXPath();
            m_Frames = new ArrayList<CFrame>();
            Element FramesElement = (Element) ((NodeList)((NodeList)xpath.evaluate("Frames", GraphDrawElement,XPathConstants.NODESET)).item(0)) ; 
            NodeList FrameListElements =(NodeList)xpath.evaluate("Frame", FramesElement,XPathConstants.NODESET);
            for (int i = 0; i < FrameListElements.getLength(); ++i) {
                Element CurrentFrameElement = (Element)FrameListElements.item(i);
                CFrame CurrentFrame = new CFrame(i+1);
                if (!CurrentFrame.Load(CurrentFrameElement)) { return false; }
                m_Frames.add(CurrentFrame);
            }
            return true;
        } catch (XPathExpressionException ex) {
            Exceptions.printStackTrace(ex);
            return false;
        }        
    }
    protected boolean LoadGraph(Element GraphDrawElement)
    {
        try {            
           XPath xpath = m_xpathFactory.newXPath();
            // LOAD NODE NAMES
           Element NodesElement = (Element)((NodeList)xpath.evaluate("Graph/Nodes", GraphDrawElement,XPathConstants.NODESET)).item(0) ;
           m_NodeNames = new TreeMap<Integer,String>();
           NodeList NodeNamesElementsList = (NodeList)xpath.evaluate("Node", NodesElement,XPathConstants.NODESET);
           for(int i=0; i<NodeNamesElementsList.getLength(); i++){
              Element CurrentNodeNameElements = (Element)NodeNamesElementsList.item(i);
              int NodeID = Integer.parseInt(CurrentNodeNameElements.getAttribute("ID"));
              String NodeName = CurrentNodeNameElements.getAttribute("Name");
              m_NodeNames.put(NodeID, NodeName);
          }
          // LOAD GRAPH EDGES 
          Element EdgesElement = (Element)((NodeList)xpath.evaluate("Graph/Edges", GraphDrawElement,XPathConstants.NODESET)).item(0) ;
          m_Graph = new ArrayList<CEdge>();
          NodeList EdgesElementsList = (NodeList)xpath.evaluate("Edge", EdgesElement,XPathConstants.NODESET);
          for(int i=0; i<EdgesElementsList.getLength(); i++){
              Element CurrentEdgeElement = (Element)EdgesElementsList.item(i);
              int From = Integer.parseInt(CurrentEdgeElement.getAttribute("From"));
              int To = Integer.parseInt(CurrentEdgeElement.getAttribute("To"));
              Float Weight = Float.parseFloat(CurrentEdgeElement.getAttribute("Weight"));
              m_Graph.add(new CEdge(From,To,Weight));
          }
          return true;
        } catch (XPathExpressionException ex) {
            Exceptions.printStackTrace(ex);
            return false; 
        }
    }    
    /**
     * Draws the graph
     * @return - true on success 
     */
    public boolean DrawGraph()
    {
        ProjectController pc = Lookup.getDefault().lookup(org.gephi.project.api.ProjectController.class);
        if (pc==null) {    System.err.println("Failed to instantiate project controller. quitting");   return false; }
        pc.newProject();
        Workspace workspace = pc.getCurrentWorkspace();        
        //Get a graph model - it exists because we have a workspace
        GraphModel graphModel = Lookup.getDefault().lookup(GraphController.class).getModel();
        Graph GraphInstance = GenerateGraph(graphModel);
        if (GraphInstance==null) { return false; }
        for (int FrameIndex = 0; FrameIndex < m_Frames.size(); ++FrameIndex ) {
            if (!DrawFrame(graphModel, GraphInstance,FrameIndex)) { return false; }
           // if (!RunLayoutAlgorithm(graphModel, GraphInstance,FrameIndex)) { return false; }
            //if (!PreviewLayout(graphModel, GraphInstance,FrameIndex)) { return false; }
            if (!ExportLayout(graphModel, GraphInstance,FrameIndex)) { return false; }
        }
        return true;
    }   
     protected boolean ExportLayout(GraphModel graphModel,org.gephi.graph.api.Graph GraphInstance, int FrameIndex)
    {
        CFrame Frame =m_Frames.get(FrameIndex);
        ExportController exportController = Lookup.getDefault().lookup(ExportController.class);
        byte[] BinaryData = null; 
        Rectangle ExportPageSize = PageSize.A0; 
        if (m_Export.m_ExportFormat.equals("png")) {
            PNGExporter pngExporter = (PNGExporter)exportController.getExporter("png");
            //pngExporter.setPageSize(ExportPageSize);
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            exportController.exportStream(baos, pngExporter);
            BinaryData = baos.toByteArray(); 
        }
        else if (m_Export.m_ExportFormat.equals("pdf")) {
            PDFExporter pdfExporter = (PDFExporter) exportController.getExporter("pdf");
            pdfExporter.setPageSize(ExportPageSize);
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            exportController.exportStream(baos, pdfExporter);
            BinaryData = baos.toByteArray();
        }
        if (BinaryData!=null) {
            OutputStream output = null;
            try {
                output = new BufferedOutputStream(new FileOutputStream(Frame.m_FileName));
                output.write(BinaryData);
            }
            catch (FileNotFoundException ex) { Exceptions.printStackTrace(ex); return false; }
            catch (java.io.IOException ex) { Exceptions.printStackTrace(ex); return false; }
            finally {
                try {
                    if (output==null) { return false; }
                    output.close();
                } catch (IOException ex) { Exceptions.printStackTrace(ex); return false;  } }
        }
        return true;
    }
    
    protected static boolean CastPropertyBoolean(String PropertyValue)    {    return (Boolean.parseBoolean(PropertyValue) || Integer.parseInt(PropertyValue)!=0);    }
    protected static float CastPropertyFloat(String PropertyValue)        {    return Float.parseFloat(PropertyValue);     }
    protected static int CastPropertyInteger(String PropertyValue)        {    return Integer.parseInt(PropertyValue);     }
    protected static Color CastPropertyColor(String PropertyValue)
    {
        try {
            Field field = Class.forName("java.awt.Color").getField(PropertyValue);
            return (Color)field.get(null);
        } catch (Exception e) { return null;    }
    }
    
    protected boolean PreviewLayout(GraphModel graphModel,org.gephi.graph.api.Graph GraphInstance, CFrame Frame)
    {
        PreviewModel model = Lookup.getDefault().lookup(PreviewController.class).getModel();
        List<String> PropertiesBoolean = new ArrayList<String>();
        PropertiesBoolean.add("DIRECTED");
        PropertiesBoolean.add("EDGE_CURVED");
        PropertiesBoolean.add("EDGE_LABEL_SHORTEN");
        PropertiesBoolean.add("EDGE_RESCALE_WEIGHT");
        PropertiesBoolean.add("MOVING");
        PropertiesBoolean.add("NODE_LABEL_PROPORTIONAL_SIZE");
        PropertiesBoolean.add("NODE_LABEL_SHORTEN");
        PropertiesBoolean.add("SHOW_EDGE_LABELS");
        PropertiesBoolean.add("SHOW_EDGES");
        PropertiesBoolean.add("SHOW_NODE_LABELS");

        List<String> PropertiesFloat = new ArrayList<String>();
        PropertiesFloat.add("ARROW_SIZE");
        PropertiesFloat.add("EDGE_LABEL_OUTLINE_OPACITY");
        PropertiesFloat.add("EDGE_LABEL_OUTLINE_SIZE");
        PropertiesFloat.add("EDGE_OPACITY");
        PropertiesFloat.add("EDGE_RADIUS");
        PropertiesFloat.add("EDGE_THICKNESS");
        PropertiesFloat.add("MARGIN");
        PropertiesFloat.add("NODE_BORDER_WIDTH");
        PropertiesFloat.add("NODE_LABEL_OUTLINE_OPACITY");
        PropertiesFloat.add("NODE_LABEL_OUTLINE_SIZE");
        PropertiesFloat.add("NODE_OPACITY");
        PropertiesFloat.add("VISIBILITY_RATIO");                

        List<String> PropertiesColor = new ArrayList<String>();
        PropertiesColor.add("BACKGROUND_COLOR");

        Map<String,String> UnsupportedProperties = new TreeMap<String,String>(); 
        UnsupportedProperties.put("EDGE_COLOR","org.gephi.preview.types.EdgeColor");
        UnsupportedProperties.put("EDGE_LABEL_COLOR","org.gephi.preview.types.DependantOriginalColor");
        UnsupportedProperties.put("EDGE_LABEL_OUTLINE_COLOR","org.gephi.preview.types.DependantColor");
        UnsupportedProperties.put("EDGE_LABEL_OUTLINE_COLOR","org.gephi.preview.types.DependantColor");
        UnsupportedProperties.put("NODE_BORDER_COLOR","org.gephi.preview.types.DependantColor");
        UnsupportedProperties.put("NODE_LABEL_COLOR","org.gephi.preview.types.DependantOriginalColor");
        UnsupportedProperties.put("NODE_LABEL_OUTLINE_COLOR","org.gephi.preview.types.DependantColor");
        UnsupportedProperties.put("EDGE_LABEL_FONT","");
        UnsupportedProperties.put("NODE_LABEL_FONT","Font");
        UnsupportedProperties.put("NODE_LABEL_BOX_COLOR","");
        UnsupportedProperties.put("NODE_LABEL_BOX_OPACITY","");
        UnsupportedProperties.put("NODE_LABEL_SHOW_BOX","");
        UnsupportedProperties.put("CATEGORY_EDGE_ARROWS","");
        UnsupportedProperties.put("CATEGORY_EDGE_LABELS","");
        UnsupportedProperties.put("CATEGORY_EDGES","");
        UnsupportedProperties.put("CATEGORY_NODE_LABELS","");
        UnsupportedProperties.put("CATEGORY_NODES","");                

        List<String> PropertiesInteger = new ArrayList<String>();
        PropertiesInteger.add("EDGE_LABEL_MAX_CHAR");                
        PropertiesInteger.add("NODE_LABEL_MAX_CHAR");

        for (int i = 0; i < Frame.m_Preview.m_SettingNames.size(); ++i ) {
            String SettingName  = Frame.m_Preview.m_SettingNames.get(i);
            String SettingValue  = Frame.m_Preview.m_SettingValues.get(i);
            String PropertyName=new String(); 
            Object PropertyValue= null; 
            Field PreviewPropertyField = null; 
            try {
                 PreviewPropertyField = Class.forName("org.gephi.preview.api.PreviewProperty").getField(SettingName);
            }  
            catch (NoSuchFieldException ex) {Exceptions.printStackTrace(ex);      } 
            catch (SecurityException ex) {     Exceptions.printStackTrace(ex);  }
            catch (ClassNotFoundException ex) {     Exceptions.printStackTrace(ex);  }
            if (PreviewPropertyField!=null) {
                try {
                    PropertyName = (String)PreviewPropertyField.get(null);
                } 
                catch (IllegalArgumentException ex) { Exceptions.printStackTrace(ex);  }
                catch (IllegalAccessException ex) { Exceptions.printStackTrace(ex); }
            
                if (PropertiesBoolean.contains(SettingName)) { PropertyValue =CastPropertyBoolean(SettingValue);}
                else if (PropertiesFloat.contains(SettingName)) { PropertyValue =CastPropertyFloat(SettingValue);}
                else if (PropertiesColor.contains(SettingName)) { PropertyValue =CastPropertyColor(SettingValue);}
                else if (PropertiesInteger.contains(SettingName)) { PropertyValue =CastPropertyInteger(SettingValue);}
                else if (UnsupportedProperties.containsKey(PropertyValue)) { PropertyValue = null;} // valid value. not yet supported
                else { PropertyValue = null; } // invalid value. 
            }
            if (!PropertyName.isEmpty() && PropertyValue!=null) { model.getProperties().putValue(PropertyName,PropertyValue); }
            
        }

        return true; 
    }
    volatile boolean m_TimeUp; 
    protected boolean RunLayoutAlgorithm(GraphModel graphModel,org.gephi.graph.api.Graph GraphInstance, CFrame Frame) 
    {
        boolean Result = true; // http://forum.gephi.org/viewtopic.php?t=2330
        if (!"None".equals( Frame.m_Algorithm.m_AlgorithmName) && Frame.m_Algorithm.m_LayoutTimeOut>0) {
            Layout LayoutAlgorithm = null;                
            if ("ForceAtlas".equals( Frame.m_Algorithm.m_AlgorithmName)) {
                LayoutAlgorithm= RunAlgorithmForceAtlas( graphModel, GraphInstance, Frame);
            }
            else if ("ForceAtlas2".equals(Frame.m_Algorithm.m_AlgorithmName)) {
                LayoutAlgorithm= RunAlgorithmForceAtlas2(graphModel, GraphInstance, Frame );
            }
            else if ("YifanHuLayout".equals(Frame.m_Algorithm.m_AlgorithmName)) {
                LayoutAlgorithm= RunAlgorithmYifanHuLayout(graphModel, GraphInstance, Frame );
            }
            else { System.err.println("Unsupported algorithm: '" + Frame.m_Algorithm.m_AlgorithmName + "'");   } // unsupported algorithm           
            if (LayoutAlgorithm!=null) {
                // run algorithm. 
                LayoutAlgorithm.initAlgo();      // http://forum.gephi.org/viewtopic.php?f=27&t=1562&sid=f2a3a805ae602988985de45660f09ab8&start=10
                
                Timer timer = new Timer(); m_TimeUp = false; 
                timer.schedule(new TimerTask(){@Override public void run(){ m_TimeUp = true; this.cancel(); }  },Frame.m_Algorithm.m_LayoutTimeOut); //http://www.roseindia.net/java/example/java/util/CertainAndRepeatTime.shtml
                while ( !m_TimeUp  && LayoutAlgorithm.canAlgo()) {
                    LayoutAlgorithm.goAlgo();
                }
                LayoutAlgorithm.endAlgo(); 
            }
            else { Result = false; } 
        }

        if (Frame.m_Algorithm.m_LabelAdjustTimeOut>0) {     
            LabelAdjust labelAdjust = new LabelAdjust(null);
            labelAdjust.setGraphModel(graphModel);
            labelAdjust.resetPropertiesValues();
            labelAdjust.setAdjustBySize(true);
            Timer timer = new Timer(); m_TimeUp = false; 
            timer.schedule(new TimerTask(){@Override public void run(){ m_TimeUp = true; this.cancel(); }  },Frame.m_Algorithm.m_LabelAdjustTimeOut); //http://www.roseindia.net/java/example/java/util/CertainAndRepeatTime.shtml
             while ( !m_TimeUp  && labelAdjust.canAlgo()) {
                   labelAdjust.goAlgo();
            }
            labelAdjust.endAlgo();
        }
        return Result; 
    }
    protected Layout RunAlgorithmForceAtlas(org.gephi.graph.api.GraphModel graphModel, org.gephi.graph.api.Graph GraphInstance, CFrame Frame)
    {
      if (!"ForceAtlas".equals(Frame.m_Algorithm.m_AlgorithmName)) { return null; } 
      // http://gephi.org/docs/toolkit/org/gephi/layout/plugin/AutoLayout.html      
      org.gephi.layout.plugin.forceAtlas.ForceAtlasLayout layout = new org.gephi.layout.plugin.forceAtlas.ForceAtlasLayout(null);
      layout.setGraphModel(graphModel);
      layout.resetPropertiesValues();  
      layout.setAdjustSizes(GetBooleanValue(Frame.m_Algorithm, "AdjustSizes",layout.isAdjustSizes()));
      layout.setAttractionStrength(GetDoubleValue(Frame.m_Algorithm, "AttractionStrength",layout.getAttractionStrength()));      
      layout.setCooling(GetDoubleValue(Frame.m_Algorithm, "Cooling",layout.getCooling()));
      layout.setFreezeBalance(GetBooleanValue(Frame.m_Algorithm, "FreezeBalance",layout.isFreezeBalance()));      
      layout.setFreezeInertia(GetDoubleValue(Frame.m_Algorithm, "FreezeInertia",layout.getFreezeInertia()));
      layout.setFreezeStrength(GetDoubleValue(Frame.m_Algorithm, "FreezeStrength",layout.getFreezeStrength()));      
      layout.setGravity(GetDoubleValue(Frame.m_Algorithm, "Gravity",layout.getGravity()));      
      layout.setInertia(GetDoubleValue(Frame.m_Algorithm, "Inertia",layout.getInertia()));
      layout.setMaxDisplacement(GetDoubleValue(Frame.m_Algorithm, "MaxDisplacement",layout.getMaxDisplacement()));
      layout.setOutboundAttractionDistribution(GetBooleanValue(Frame.m_Algorithm, "OutboundAttractionDistribution",layout.isOutboundAttractionDistribution()));      
      layout.setRepulsionStrength(GetDoubleValue(Frame.m_Algorithm, "RepulsionStrength",layout.getRepulsionStrength()));
      layout.setSpeed(GetDoubleValue(Frame.m_Algorithm, "Speed",layout.getSpeed()));      
      return layout; 
    }
  
    protected Layout RunAlgorithmForceAtlas2(org.gephi.graph.api.GraphModel graphModel, org.gephi.graph.api.Graph GraphInstance, CFrame Frame)
    {
      if (!"ForceAtlas2".equals(Frame.m_Algorithm.m_AlgorithmName)) { return null; }       
       ForceAtlas2 layout = new ForceAtlas2(new ForceAtlas2Builder());
       layout.setGraphModel(graphModel);
       layout.resetPropertiesValues();  
        // http://gephi.org/docs/toolkit/index.html?org/gephi/layout/plugin/force/yifanHu/YifanHuLayout.html        
        layout.setAdjustSizes(GetBooleanValue(Frame.m_Algorithm, "AdjustSizes",layout.isAdjustSizes()));
        layout.setBarnesHutOptimize(GetBooleanValue(Frame.m_Algorithm, "BarnesHutOptimize",layout.isBarnesHutOptimize()));
        layout.setBarnesHutTheta(GetDoubleValue(Frame.m_Algorithm, "BarnesHutTheta",layout.getBarnesHutTheta()));
        layout.setEdgeWeightInfluence(GetDoubleValue(Frame.m_Algorithm, "EdgeWeightInfluence",layout.getEdgeWeightInfluence()));
        layout.setGravity(GetDoubleValue(Frame.m_Algorithm, "Gravity",layout.getGravity()));
        layout.setJitterTolerance(GetDoubleValue(Frame.m_Algorithm, "JitterTolerance",layout.getJitterTolerance()));        
        layout.setLinLogMode(GetBooleanValue(Frame.m_Algorithm, "LinLogMode",layout.isLinLogMode()));
        layout.setOutboundAttractionDistribution(GetBooleanValue(Frame.m_Algorithm, "OutboundAttractionDistribution",layout.isOutboundAttractionDistribution()));
        layout.setScalingRatio(GetDoubleValue(Frame.m_Algorithm, "ScalingRatio",layout.getScalingRatio()));
        layout.setStrongGravityMode(GetBooleanValue(Frame.m_Algorithm, "StrongGravityMode",layout.isStrongGravityMode()));
        layout.setThreadsCount(GetIntegerValue(Frame.m_Algorithm, "ThreadsCount",layout.getThreadsCount()));
       return layout; 
    }
    protected Layout RunAlgorithmYifanHuLayout(org.gephi.graph.api.GraphModel graphModel,org.gephi.graph.api.Graph GraphInstance,  CFrame Frame)
    {
      if (!"YifanHuLayout".equals(Frame.m_Algorithm.m_AlgorithmName)) { return null; }      
      // http://gephi.org/docs/toolkit/index.html?org/gephi/layout/plugin/force/yifanHu/YifanHuLayout.html
        float stepDisplacement =  GetFloatValue(Frame.m_Algorithm, "StepDisplacement", 1f);
        YifanHuLayout layout = new YifanHuLayout(null, new StepDisplacement(stepDisplacement));
        layout.setGraphModel(graphModel);
        layout.resetPropertiesValues();   
        
        layout.setAdaptiveCooling(GetBooleanValue(Frame.m_Algorithm, "AdaptiveCooling",layout.isAdaptiveCooling()));
        
        layout.setBarnesHutTheta(GetFloatValue(Frame.m_Algorithm, "BarnesHutTheta",layout.getBarnesHutTheta()));
        layout.setConvergenceThreshold(GetFloatValue(Frame.m_Algorithm, "ConvergenceThreshold",layout.getConvergenceThreshold()));
        layout.setInitialStep(GetFloatValue(Frame.m_Algorithm, "InitialStep",layout.getInitialStep()));
        layout.setOptimalDistance(GetFloatValue(Frame.m_Algorithm, "OptimalDistance",layout.getOptimalDistance()));
        
        layout.setQuadTreeMaxLevel(GetIntegerValue(Frame.m_Algorithm, "QuadTreeMaxLevel",layout.getQuadTreeMaxLevel()));
        layout.setRelativeStrength(GetFloatValue(Frame.m_Algorithm, "RelativeStrength",layout.getRelativeStrength()));
        layout.setStepRatio(GetFloatValue(Frame.m_Algorithm, "StepRatio",layout.getStepRatio()));        
        return layout; 
    }
    protected boolean DrawFrame(GraphModel graphModel,org.gephi.graph.api.Graph GraphInstance, int FrameIndex)
    {
        CFrame Frame =m_Frames.get(FrameIndex);
        boolean GraphChanged = false; // Frame.m_NodesRemove.length>0 || Frame.m_NodesAdd.length>0 ; // true of the layout algorithm must be run again
        // remove nodes 
        for (int i = 0; i < Frame.m_NodesRemove.length; ++i) {
            org.gephi.graph.api.Node CurrentNode = GraphInstance.getNode(Integer.toString(Frame.m_NodesRemove[i]));
            if (CurrentNode!=null) { GraphInstance.removeNode(CurrentNode); GraphChanged  =true; }                
        }            
        // add nodes 
        for (int i = 0; i < Frame.m_NodesAdd.length; ++i) {
            String NodeName = this.m_NodeNames.get(Frame.m_NodesAdd[i]);
            if (GraphInstance.getNode(NodeName)==null) {  AddNode(graphModel, GraphInstance, Frame.m_NodesAdd[i],NodeName); GraphChanged  =true;   }
        }            
        // remove edges
        for (int i = 0; i < Frame.m_EdgesRemove[0].length; ++i) {
            org.gephi.graph.api.Node Source = GraphInstance.getNode(Integer.toString(Frame.m_EdgesRemove[0][i]));
            org.gephi.graph.api.Node Dest = GraphInstance.getNode(Integer.toString(Frame.m_EdgesRemove[1][i]));
            if (Source!=null && Dest!=null) { 
                org.gephi.graph.api.Edge CurrentEdge = GraphInstance.getEdge(Source,Dest);
                if (CurrentEdge!=null) { GraphInstance.removeEdge(CurrentEdge); GraphChanged  =true; }
            }       
        }
        // add edges
        for (int i = 0; i < Frame.m_EdgesAdd[0].length; ++i) {
            org.gephi.graph.api.Node Source = GraphInstance.getNode(Integer.toString(Frame.m_EdgesAdd[0][i]));
            if (Source==null) {  AddNode(graphModel, GraphInstance, Frame.m_EdgesAdd[0][i],this.m_NodeNames.get(Frame.m_EdgesAdd[0][i])); GraphChanged  =true;  }
            Source = GraphInstance.getNode(Integer.toString(Frame.m_EdgesAdd[0][i]));
            
            org.gephi.graph.api.Node Dest = GraphInstance.getNode(Integer.toString(Frame.m_EdgesAdd[1][i]));
            if (Dest==null) {  AddNode(graphModel, GraphInstance, Frame.m_EdgesAdd[1][i],this.m_NodeNames.get(Frame.m_EdgesAdd[1][i])); GraphChanged  =true;  }
            Dest = GraphInstance.getNode(Integer.toString(Frame.m_EdgesAdd[1][i]));
            
            if (GraphInstance.getEdge(Source, Dest)==null) {  GraphInstance.addEdge(graphModel.factory().newEdge(Source,Dest)); GraphChanged = true; }
        }
        
        for (int PropertyID = 0; PropertyID < Frame.m_NodeProperties.size(); ++PropertyID ) {
            CNodeProperties CurrentProperties = Frame.m_NodeProperties.get(PropertyID);
            if (CurrentProperties.m_NodeIDs.length==0) { // all!
                for(org.gephi.graph.api.Node node : GraphInstance.getNodes().toArray()) {
                    node.getNodeData().setColor(CurrentProperties.m_Color[0], CurrentProperties.m_Color[1], CurrentProperties.m_Color[2]);
                    node.getNodeData().setSize(CurrentProperties.m_Size);
                    node.getNodeData().getTextData().setSize(CurrentProperties.m_LabelSize);
                }
            }
            else {
                for (int NodeID : CurrentProperties.m_NodeIDs ){
                    org.gephi.graph.api.Node node = GraphInstance.getNode(Integer.toString(NodeID));
                    if (node!=null){                        
                        node.getNodeData().getTextData().setSize(CurrentProperties.m_LabelSize);
                        if (CurrentProperties.m_LabelSize==0) {
                            node.getNodeData().setLabel(null);
                        }
                        node.getNodeData().setColor(CurrentProperties.m_Color[0], CurrentProperties.m_Color[1], CurrentProperties.m_Color[2]);
                        node.getNodeData().setSize(CurrentProperties.m_Size);                          
                        
                    }
                }            
            }
        }
        for (int PropertyID = 0; PropertyID < Frame.m_EdgeProperties.size(); ++PropertyID ) {
            CEdgeProperties CurrentProperties = Frame.m_EdgeProperties.get(PropertyID);
            if (CurrentProperties.m_Edges[0].length==0) { // all!
                for(org.gephi.graph.api.Edge edge : GraphInstance.getEdges().toArray()) {
                    edge.getEdgeData().setColor(CurrentProperties.m_Color[0], CurrentProperties.m_Color[1], CurrentProperties.m_Color[2]);
                    edge.getEdgeData().setSize(CurrentProperties.m_Size);
                }
            }
            else {
                for (int index =0; index <  CurrentProperties.m_Edges[0].length;++index ){
                    org.gephi.graph.api.Node Source = GraphInstance.getNode(Integer.toString(CurrentProperties.m_Edges[0][index]));
                    org.gephi.graph.api.Node Dest = GraphInstance.getNode(Integer.toString(CurrentProperties.m_Edges[1][index]));
                    if (Source!=null && Dest!=null) {
                        org.gephi.graph.api.Edge edge = GraphInstance.getEdge(Source,Dest);
                        if (edge!=null) { 
                            edge.getEdgeData().setColor(CurrentProperties.m_Color[0], CurrentProperties.m_Color[1], CurrentProperties.m_Color[2]); 
                            edge.getEdgeData().setSize(CurrentProperties.m_Size);
                        }
                    }                    
                }            
            }
        }
        if (!RunLayoutAlgorithm(graphModel,GraphInstance, Frame)) { return false; }
        if (!PreviewLayout(graphModel, GraphInstance,Frame)) { return false; }
        return true;
    }
    
    protected org.gephi.graph.api.Graph GenerateGraph(GraphModel graphModel)
    {      
        org.gephi.graph.api.Graph GraphInstance = null; 
        if (m_IsDirected) {  GraphInstance = graphModel.getDirectedGraph(); }
        else { GraphInstance = graphModel.getUndirectedGraph(); }
        
        Map<Integer, org.gephi.graph.api.Node> m_Nodes = new TreeMap<Integer,org.gephi.graph.api.Node>();
        for (Map.Entry<Integer, String> entry : m_NodeNames.entrySet())
        {
//            org.gephi.graph.api.Node  CurrentNode = AddNode(graphModel, GraphInstance, entry);
            org.gephi.graph.api.Node  CurrentNode = AddNode(graphModel, GraphInstance, entry.getKey(),entry.getValue());
         //   CurrentNode.getNodeData().setLabel(entry.getValue());            
          //  GraphInstance.addNode(CurrentNode);
            m_Nodes.put(entry.getKey(),CurrentNode);
        }
        Map<Integer, org.gephi.graph.api.Edge> m_Edges = new TreeMap<Integer,org.gephi.graph.api.Edge>();
        for ( int i=0; i< m_Graph.size(); ++i)
        {
            CEdge CurrentEdgeIterator = m_Graph.get(i);
            if (!m_Nodes.containsKey(CurrentEdgeIterator.From)) { 
                org.gephi.graph.api.Node  CurrentNode = AddNode(graphModel, GraphInstance, CurrentEdgeIterator.From,Integer.toString(CurrentEdgeIterator.From) );
                m_Nodes.put(CurrentEdgeIterator.From,CurrentNode);
            }
            if (!m_Nodes.containsKey(CurrentEdgeIterator.To)) { 
                org.gephi.graph.api.Node  CurrentNode = AddNode(graphModel, GraphInstance, CurrentEdgeIterator.To,Integer.toString(CurrentEdgeIterator.To) );
                m_Nodes.put(CurrentEdgeIterator.To,CurrentNode);
            }
            org.gephi.graph.api.Edge  CurrentEdge = graphModel.factory().newEdge( m_Nodes.get(CurrentEdgeIterator.From),  m_Nodes.get(CurrentEdgeIterator.To),CurrentEdgeIterator.Weight, m_IsDirected); 
            GraphInstance.addEdge(CurrentEdge);
            m_Edges.put(m_Edges.size()+1, CurrentEdge);
        }
        return GraphInstance; 
    }
    org.gephi.graph.api.Node AddNode(GraphModel graphModel,org.gephi.graph.api.Graph GraphInstance, Integer ID, String Name)
    {
        //graphModel.factory().newNode("n0");
            org.gephi.graph.api.Node  CurrentNode = graphModel.factory().newNode(ID.toString());
            CurrentNode.getNodeData().setLabel(Name);            
            GraphInstance.addNode(CurrentNode);
            return CurrentNode; 
    }
  /*  org.gephi.graph.api.Node AddNode(GraphModel graphModel,org.gephi.graph.api.Graph GraphInstance, Map.Entry<Integer, String> entry)
    {
        //graphModel.factory().newNode("n0");
            org.gephi.graph.api.Node  CurrentNode = graphModel.factory().newNode(entry.getKey().toString());
            CurrentNode.getNodeData().setLabel(entry.getValue());            
            GraphInstance.addNode(CurrentNode);
            return CurrentNode; 
    }*/
      protected boolean GetBooleanValue(CAlgorithm Algorithm, String FieldName, boolean DefaultValue )     {         return GetBooleanValue(Algorithm.m_SettingNames,Algorithm.m_SettingValues,FieldName,DefaultValue);    }
    protected boolean GetBooleanValue(List<String> Names, List<String> Values, String FieldName, boolean DefaultValue )
    {
      if (!Names.contains(FieldName))  { return DefaultValue; }
      String ResStr = Values.get(Names.indexOf(FieldName));
      return (Boolean.parseBoolean(ResStr) || Integer.parseInt(ResStr)>0);
    }
    protected double GetDoubleValue(CAlgorithm Algorithm, String FieldName, double DefaultValue )     {         return GetDoubleValue(Algorithm.m_SettingNames,Algorithm.m_SettingValues,FieldName,DefaultValue);    }
    protected double GetDoubleValue(List<String> Names, List<String> Values, String FieldName, double DefaultValue )
    {
      if (!Names.contains(FieldName))  { return DefaultValue; }
      return Double.parseDouble(Values.get(Names.indexOf(FieldName)));
    }
    protected float GetFloatValue(CAlgorithm Algorithm, String FieldName, float DefaultValue )     {         return GetFloatValue(Algorithm.m_SettingNames,Algorithm.m_SettingValues,FieldName,DefaultValue);    }
    protected float GetFloatValue(List<String> Names, List<String> Values, String FieldName, float DefaultValue )
    {
      if (!Names.contains(FieldName))  { return DefaultValue; }
      return Float.parseFloat(Values.get(Names.indexOf(FieldName)));
    }
    protected int GetIntegerValue(CAlgorithm Algorithm, String FieldName, int DefaultValue )     {         return GetIntegerValue(Algorithm.m_SettingNames,Algorithm.m_SettingValues,FieldName,DefaultValue);    }
    protected int GetIntegerValue(List<String> Names, List<String> Values, String FieldName, int DefaultValue )
    {
      if (!Names.contains(FieldName))  { return DefaultValue; }
      return Integer.parseInt(Values.get(Names.indexOf(FieldName)));
    }
    
    private XPathFactory m_xpathFactory;
    protected File  m_XMLFile; 
    protected boolean m_IsDirected; 
    protected Map<Integer,String> m_NodeNames;  
    protected List<CEdge> m_Graph; // 
    protected List<CFrame> m_Frames; //     
    protected CExport m_Export; 
}
