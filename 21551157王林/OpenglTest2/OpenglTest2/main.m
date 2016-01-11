//
//  main.m
//  OpenglTest2
//
//  Created by 王林 on 16/1/11.
//  Copyright © 2016年 sjaiwl. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <GLUT/GLUT.h>
#include <OpenGL/gl.h>
#include <OpenGL/glu.h>
#include <SDL2/SDL.h>

static int year = 0, day = 0;

GLUquadricObj *sunQuadObj;
GLUquadricObj *moonQuadObj;
GLUquadricObj *earthQuadObj;

SDL_Surface* sunSurface = NULL;
SDL_Surface* moonSurface = NULL;
SDL_Surface* earthSurface = NULL;

GLuint sunTexture;
GLuint moonTexture;
GLuint earthTexture;

void init(){
    //创建二次曲面对象
    sunQuadObj = gluNewQuadric();
    //设置法线风格->一般使用GLU_SMOOTH风格，对每个顶点都计算法线向量（默认方式）
    gluQuadricNormals(sunQuadObj, GLU_SMOOTH);
    //设置纹理——》自动计算纹理
    gluQuadricTexture(sunQuadObj, GLU_TRUE);
    
    moonQuadObj = gluNewQuadric();
    gluQuadricNormals(moonQuadObj, GLU_SMOOTH);
    gluQuadricTexture(moonQuadObj, GLU_TRUE);
    
    earthQuadObj = gluNewQuadric();
    gluQuadricNormals(earthQuadObj, GLU_SMOOTH);
    gluQuadricTexture(earthQuadObj, GLU_TRUE);
    
    glTexGeni(GL_S, GL_TEXTURE_GEN_MODE, GL_SPHERE_MAP);
    glTexGeni(GL_T, GL_TEXTURE_GEN_MODE, GL_SPHERE_MAP);
    
    sunSurface = SDL_LoadBMP("sun.bmp");
    //glGenTextures函数根据纹理参数返回n个纹理索引。
    //第一个参数n：用来生成纹理的数量
    //第二个参数textures：存储纹理索引的第一个元素指针
    glGenTextures(1, &sunTexture);
    //允许建立一个绑定到目标纹理的有名称的纹理
    //第一个参数target：纹理被绑定的目标
    //第二个参数texture：纹理的名称
    glBindTexture(GL_TEXTURE_2D, sunTexture);
    //根据指定的参数生成一个2D纹理
    glTexImage2D(GL_TEXTURE_2D, 0, 3, sunSurface->w, sunSurface->h, 0, GL_BGR, GL_UNSIGNED_BYTE, sunSurface->pixels);
    //用glTexParmeteri()函数来确定如何把纹理像素映射成像素
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    moonSurface = SDL_LoadBMP("moon.bmp");
    glGenTextures(1, &moonTexture);
    glBindTexture(GL_TEXTURE_2D, moonTexture);
    glTexImage2D(GL_TEXTURE_2D, 0, 3, moonSurface->w, moonSurface->h, 0, GL_BGR, GL_UNSIGNED_BYTE, moonSurface->pixels);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_REPEAT);
    
    earthSurface = SDL_LoadBMP("earth.bmp");
    glGenTextures(1, &earthTexture);
    glBindTexture(GL_TEXTURE_2D, earthTexture);
    glTexImage2D(GL_TEXTURE_2D, 0, 3, earthSurface->w, earthSurface->h, 0, GL_BGR, GL_UNSIGNED_BYTE, earthSurface->pixels);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_REPEAT);
    
    //启动某种功能
    glEnable(GL_TEXTURE_2D);
    glEnable(GL_LIGHTING);
    glEnable(GL_LIGHT0);
    glEnable(GL_DEPTH_TEST);
}

void display(void)
{
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    //当前状态压栈
    glPushMatrix();
    //设置太阳光照
    GLfloat lightPosition[] = {0.0f, 0.0f, 0.0f, 1.0f};
    GLfloat lightAmbient[] = {1.0f, 1.0f, 1.0f, 1.0f};
    GLfloat lightDiffuse[] = {1.0f, 1.0f, 1.0f, 1.0f};
    GLfloat lightSpecular[] = {1.0f, 1.0f, 1.0f, 1.0f};
    glLightfv(GL_LIGHT1, GL_POSITION, lightPosition); //光源的位置
    glLightfv(GL_LIGHT1, GL_AMBIENT, lightAmbient); //环境光强
    glLightfv(GL_LIGHT1, GL_DIFFUSE, lightDiffuse); //漫发射光强
    glLightfv(GL_LIGHT1, GL_SPECULAR, lightSpecular); //镜面发射光
    
    //定义太阳的材质并绘制太阳
    GLfloat sunAmbient[] = {1.0f, 1.0f, 1.0f, 1.0f};
    GLfloat sunDiffuse[] = {0.0f, 0.0f, 0.0f, 1.0f};
    GLfloat sunSpecular[] = {0.0f, 0.0f, 0.0f, 1.0f};
    GLfloat sunEmission[] = {0.5f, 0.5f, 0.5f, 1.0f};
    GLfloat sunshine = 30.0f;
    glMaterialfv(GL_FRONT, GL_AMBIENT, sunAmbient); //材质的环境颜色
    glMaterialfv(GL_FRONT, GL_DIFFUSE, sunDiffuse); //材质的散射颜色
    glMaterialfv(GL_FRONT, GL_SPECULAR, sunSpecular); //材质的镜面发射颜色
    glMaterialfv(GL_FRONT, GL_EMISSION, sunEmission); //镜面反射指数
    glMaterialf(GL_FRONT, GL_SHININESS, sunshine);
    
    glBindTexture(GL_TEXTURE_2D, sunTexture);
    glRotatef(year, 0, 0, 1);//旋转角度以及所绕的轴
    gluSphere(sunQuadObj, 1, 20, 20);//设置球体半径和分割
    
    //定义地球材质并绘制地球
    GLfloat earthEmission[] = { 0.5f, 0.5f, 0.5f, 1.0f };
    GLfloat earthAmbient[] = {1.0f, 1.0f, 1.0f, 1.0f};
    GLfloat earthDiffuse[] = {0.0f, 0.0f, 0.5f, 1.0f};
    GLfloat earthSpecular[] = {1.0f, 1.0f, 1.0f, 1.0f};
    GLfloat earthshine = 30.0f;
    glMaterialfv(GL_FRONT, GL_AMBIENT, earthAmbient); //材质的环境颜色
    glMaterialfv(GL_FRONT, GL_DIFFUSE, earthDiffuse); //材质的散射颜色
    glMaterialfv(GL_FRONT, GL_SPECULAR, earthSpecular); //材质的镜面发射颜色
    glMaterialfv(GL_FRONT, GL_EMISSION, earthEmission); //镜面反射指数
    glMaterialf(GL_FRONT, GL_SHININESS, earthshine);
    
    glBindTexture(GL_TEXTURE_2D, earthTexture);
    glTranslated(2.0, 0, 0);
    glRotatef(day, 0, 1, 0);
    gluSphere(sunQuadObj, 0.3, 20, 20);
    
    //定义月球材质并绘制月球
    GLfloat moonAmbient[] = { 1.0f, 1.0f, 1.0f, 1.0f };
    GLfloat moonDiffuse[] = { 0.1f, 0.1f, 0.1f, 1.0f };
    GLfloat moonSpecular[] = { 1.0f, 1.0f, 1.0f, 1.0f };
    GLfloat moonEmission[] = { 0.5f, 0.5f, 0.5f, 1.0f };
    GLfloat moonshine = 30.0f;
    glMaterialfv(GL_FRONT, GL_AMBIENT, moonAmbient);
    glMaterialfv(GL_FRONT, GL_DIFFUSE, moonDiffuse);
    glMaterialfv(GL_FRONT, GL_SPECULAR, moonSpecular);
    glMaterialfv(GL_FRONT, GL_EMISSION, moonEmission);
    glMaterialf(GL_FRONT, GL_SHININESS, moonshine);
    
    glBindTexture(GL_TEXTURE_2D, moonTexture);
    glTranslated(0.6, 0, 0);
    gluSphere(moonQuadObj, 0.15, 15, 15);
    glPopMatrix();
    
    glutSwapBuffers();
    glFlush();
}

void reshape(int w, int h)
{
    //设置机口
    glViewport(0, 0, (GLsizei) w, (GLsizei) h);
    //指定哪一个矩阵是当前矩阵
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    //创建透视投影矩阵(fovy, aspect, zNear, zFar)
    gluPerspective(60, (GLfloat)w/(GLfloat)h, 1.0, 20);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    //glFrustum(-1, 1, -1, 1, 1.5, 20.0);
    //用透视矩阵乘以当前矩阵(left, right, bottom, top, near, far)
    gluLookAt(0, 5, 5, 0, 0, 0, 0, 1, 0);
}

void idle()
{
    int moonDay = moonDay + 0.1;
    if (moonDay >= 360)
    {
        moonDay -= 360;
    }
    
    int moonMonth = moonMonth + 0.04;
    if (moonMonth >= 360)
    {
        moonMonth -= 360;
    }
    day = day + 0.05;
    if (day >= 360)
    {
        day -= 360;
    }
    year = year + 0.03;
    if (day >= 360)
    {
        year -= 360;
    }
    int startYear = startYear + 0.02;
    if (startYear >= 360)
    {
        startYear -= 360;
    }
    //重绘
    glutPostRedisplay();
}

int main(int argc, char * argv[]) {
    
    //初始化
    glutInit(&argc, argv);
    
    /**
     *窗口设置
     */
    //设置窗口显示模式
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGBA | GLUT_DEPTH);
    //设置窗口位置
    glutInitWindowPosition(111, 111);
    //设置窗口大小
    glutInitWindowSize(888, 888);
    //设置窗口名称
    glutCreateWindow("21551123_杨雪琪_OPENGL第二次作业");
    init();
    glutDisplayFunc(display);
    glutReshapeFunc(reshape);
    glutIdleFunc(idle);
    glutMainLoop();
    
    return 0;
}
