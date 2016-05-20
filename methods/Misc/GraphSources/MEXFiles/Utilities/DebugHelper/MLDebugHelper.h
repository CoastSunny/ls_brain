
#ifndef ML_DEBUG_HELPER
#define ML_DEBUG_HELPER


//------------------------------------------------------------------------
#include <string>
//------------------------------------------------------------------------
enum EMLDebugHelper {
	dbEndl,
	dbFlush,
};
//------------------------------------------------------------------------

//------------------------------------------------------------------------
class TMLDebugHelper {
public:
		TMLDebugHelper () :  FStr() {}
		virtual ~TMLDebugHelper() {}

		

		TMLDebugHelper& Flush();

		friend TMLDebugHelper& operator<< (TMLDebugHelper& out, EMLDebugHelper value);
		friend TMLDebugHelper& operator<< (TMLDebugHelper& out, int value);
		friend TMLDebugHelper& operator<< (TMLDebugHelper& out, unsigned int value);
#ifdef _M_X64
		friend TMLDebugHelper& operator<< (TMLDebugHelper& out, size_t value);
#endif //#ifdef _M_X64
		friend TMLDebugHelper& operator<< (TMLDebugHelper& out, double value);
		friend TMLDebugHelper& operator<< (TMLDebugHelper& out, char value);

		friend TMLDebugHelper& operator<< (TMLDebugHelper& out, const char* value)		{ return out.AppendString(value);  }		
		friend TMLDebugHelper& operator<< (TMLDebugHelper& out, const std::string& value) { return out.AppendString(value);  }
		
		//template <typename T> TMLDebugHelper& operator<< (const T& value);

		inline void Clear()				{ FStr.clear(); }
		inline TMLDebugHelper& AppendString(const char* value)			{ FStr += std::string(value); return *this; }		
		inline TMLDebugHelper& AppendString(const std::string& value)	{ FStr += value ; return *this; }		
		inline const std::string& Str() const							{ return FStr; }
protected:

private:
	std::string	FStr;
};

#endif // ML_DEBUG_HELPER