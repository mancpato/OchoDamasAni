/*
  OchoDamas
  
  Se recrea la animación de la búsqueda de soluciones 
  para el problema de las ocho reinas.
  
  Se resuelve simulando la recursividad con una pila.
  
  manc, 2021
*/

import java.util.Stack;

int Tam = 50;
color ColorNegras = #0D9802;
color ColorBlancas = #FEFFBF;

PImage Dama;

char[][] T;
int N = 8;
int Soluciones;
int Espera = 500;

Stack<Movs> Pila = new Stack<Movs>();
ArrayList<Movs> Movidas = new ArrayList();

void setup() 
{
    size(580,580);
    textAlign(CENTER,CENTER);
    Dama = loadImage("Dama.png");
    Dama.resize(int(Tam*.8), int(Tam*.8));
    textSize(18);
    
    Soluciones=0;
    
    T = new  char[N][N];
    for ( int i=0 ; i<N ; i++ )
        for ( int j=0 ; j<N ; j++ )
            T[i][j] = '-';

    for ( int r=0 ; r<N ; r++ ) {
        Movs M = new Movs(r, 0, 0);
        Pila.push(M);
    }
    println("Problema de las ocho reinas");
}

void  draw() 
{
    int c, r;
    background(255);
    noStroke();
    
    DibujarTablero();
    
    if ( !Pila.empty() ) {
        Movs M = Pila.pop();
        r = M.i;
        c = M.j;
        QuitarDamas(c); //<>//
        if ( SePuede(r, c) ) 
            PonerDama(r,c++);
    
        if ( c == N ) {
            Soluciones++;
            DibujarTablero();
            Espera = 500;
            print("Frame:", frameCount);
            println(",  Solución",Soluciones);
            MostrarTablero();
            QuitarDama(r, --c);
            noLoop();
        } else {
            for ( int i=0 ; i<N ; i++ )
                if ( SePuede(i, c) ) {
                    M = new Movs(i, c, 1);
                    Pila.push(M);
                }
        }
    }

    Espera -= 10;
    if ( Espera<50 )
        Espera = 50;
    delay(Espera);
}

void PonerDama(int r, int c)
{
    T[r][c] = 'D';
}

void QuitarDama(int r, int c)
{
    T[r][c] = '-';
}

void QuitarDamas(int c)
{
    for ( int j=7 ; c <= j ; j-- )
        for ( int i=0 ; i<N ; i++ )
            if ( T[i][j] == 'D' ) {
                QuitarDama(i, j);
                break;
            }
} //<>//

boolean SePuede(int r, int c)
{
    int i, j;

    for ( i=0; i<N ; i++ )
        if ( T[i][c] == 'D' )
            return false;

    for ( i=0; i<N ; i++ )
        if ( T[r][i] == 'D' )
            return false;

    int m = r<c ? r : c;
    for ( i=r-m, j=c-m ; i<N && j<N ; i++,j++ )
        if ( T[i][j] == 'D' )
            return false;

    for ( i=r+1, j=c-1; i<N && j>=0 ; i++, j--)
        if ( T[i][j] == 'D' )
            return false;
    for ( i=r-1, j=c+1; i>=0 && j<N ; i--, j++)
        if ( T[i][j] == 'D' )
            return false;

    return true;
}
 //<>//
void DibujarTablero()
{
    fill(ColorNegras);
    rect(Tam, Tam, Tam*10, Tam*10);
    
    color c;
    fill(ColorBlancas);
    rect(2*Tam-Tam/5, 1.8*Tam, 8.4*Tam, 8.4*Tam);
    for (int i = 0; i < 8 ; i++) {
        for (int j = 0; j < 8 ; j++) {
            c = (i+j)%2==0 ? ColorNegras : ColorBlancas;
            fill(c);
            rect(2*Tam + j*Tam, 2*Tam + i*Tam, Tam, Tam);
            if ( T[i][j] == 'D' )
                image(Dama, 2*Tam+5 + j*Tam, 2*Tam+5 + i*Tam);
        }
    }
    
    fill(255);
    for (int i = 1; i <= 8 ; i++) {
        text(i, 1.5*Tam, 10.5*Tam-i*(Tam+1));
        text(char(64+i), 1.5*Tam+i*Tam, 10.4*Tam);
    }
}

void MostrarTablero()
{
    for (int i =0; i<N; i++) {
        for(int  j = 0; j<N; j++)
            print(T[i][j], "");
        println("");
    }
    println("");
}

void mouseClicked()
{
  loop();
}
