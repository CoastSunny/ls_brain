clear all
close all

% specifying the exact locations of the target and the sensors using x,y and z coordinates 
c = 3e8;
T = [265; 435; 3];
R1 = [449.0000; 250; 1.5];
R2 = [276.0000; 175.0000; 1.5];
R3 = [99.0000; 299.0000; 1.5];
R4 = [469.0000;  190.0000; 1.5];
R5 = [314.0000; 198.0000; 1.5];
R6 = [104.0000; 283.0000; 1.5];
R7 = [189.0000; 217.0000; 1.5];
R8 = [463.0000; 120.0000; 1.5];
R9 = [44.0000; 261.000; 1.5];
R10 = [157.0000; 357.0000; 1.5];

% plotting the positions
scatter3(T(1),T(2),T(3),'rx'); hold on
scatter3(R1(1),R1(2),R1(3),'filled'); hold on
scatter3(R2(1),R2(2),R2(3),'filled'); hold on
scatter3(R3(1),R3(2),R3(3),'filled'); hold on
scatter3(R4(1),R4(2),R4(3),'filled'); hold on
scatter3(R5(1),R5(2),R5(3),'filled'); hold on
scatter3(R6(1),R6(2),R6(3),'filled'); hold on
scatter3(R7(1),R7(2),R7(3),'filled'); hold on
scatter3(R8(1),R8(2),R8(3),'filled'); hold on
scatter3(R9(1),R9(2),R9(3),'filled'); hold on
scatter3(R10(1),R10(2),R10(3),'filled'); hold off
% calculating the distances between all 10 sensors and the target
d1 = sqrt((T(1)-R1(1))^2+ (T(2)-R1(2))^2+ (T(3)-R1(3))^2);
d2 = sqrt((T(1)-R2(1))^2+ (T(2)-R2(2))^2+ (T(3)-R2(3))^2);
d3 = sqrt((T(1)-R3(1))^2+ (T(2)-R3(2))^2+ (T(3)-R3(3))^2);
d4 = sqrt((T(1)-R4(1))^2+ (T(2)-R4(2))^2+ (T(3)-R4(3))^2);
d5 = sqrt((T(1)-R5(1))^2+ (T(2)-R5(2))^2+ (T(3)-R5(3))^2);
d6 = sqrt((T(1)-R6(1))^2+ (T(2)-R6(2))^2+ (T(3)-R6(3))^2);
d7 = sqrt((T(1)-R7(1))^2+ (T(2)-R7(2))^2+ (T(3)-R7(3))^2);
d8 = sqrt((T(1)-R8(1))^2+ (T(2)-R8(2))^2+ (T(3)-R8(3))^2);
d9 = sqrt((T(1)-R9(1))^2+ (T(2)-R9(2))^2+ (T(3)-R9(3))^2);
d10 = sqrt((T(1)-R10(1))^2+ (T(2)-R10(2))^2+ (T(3)-R10(3))^2);

% calculating the time target signal reaches  each sensor (if needed)
t1 = d1/c; t2 = d2/c; t3 = d3/c;  t4 = d4/c; t5 = d5/c; t6 = d6/c; 
t7 = d7/c; t8 = d8/c; t9 = d9/c; t10 = d10/c; 
 
 



