#define ALLEGRO_STATICLINK
#include <allegro.h>
#include <iostream>
#include <fstream>
#include <string>
#include <map>
using namespace std;

typedef unsigned char byte;
map<char, int> hexmap;
map<int, byte> pallete;

void loadhexmap() {
    cout << "Loading hexmap" << endl;
    hexmap['0'] = 0;  hexmap['1'] = 1;
    hexmap['2'] = 2;  hexmap['3'] = 3;
    hexmap['4'] = 4;  hexmap['5'] = 5;
    hexmap['6'] = 6;  hexmap['7'] = 7;
    hexmap['8'] = 8;  hexmap['9'] = 9;
    hexmap['a'] = 10; hexmap['b'] = 11;
    hexmap['c'] = 12; hexmap['d'] = 13;
    hexmap['e'] = 14; hexmap['f'] = 15;
}

void loadpallete(string file = "rwk.txt") {
    cout << "Loading pallete " << file << endl;
    ifstream in(file.c_str());
    string line;
    int i = 0;
    while(getline(in, line)) {
        if(line[0] == '/' && line[1] == '/') continue;
        int tile = 0, i = 0;
        while(line[i] != ' ') {
            tile = tile*10 + hexmap[line[i]];
            ++i;
        }
        int r = 16*hexmap[line[++i]] + hexmap[line[++i]];
        int g = 16*hexmap[line[++i]] + hexmap[line[++i]];
        int b = 16*hexmap[line[++i]] + hexmap[line[++i]];
        ++i;
        pallete[makecol32(r, g, b)] = tile;
    }
    cout << i << " entries loaded" << endl;
}

void convert(BITMAP* bmp, string file = "map.raw") {
    cout << "Saving " << file << endl;
    ofstream out(file.c_str(), ios_base::out | ios_base::binary);

    int w = bmp->w; int h = bmp->h;

    for(int y = 0; y < h; ++y) {
        for(int x = 0; x < w; ++x) {
            int col = getpixel(bmp, x, y);
            byte ind = pallete[col];
            if(ind == 0 && col != makecol32(0, 0, 0)) {
                //cout << "Unknown color at (" << x << "," << y << ")" << endl;
            }
            out << ind;
        }
    }
}

int main(int argc, char* argv[]) {
    allegro_init();
    set_color_depth(32);

    string map = "map.bmp";
    if(argc > 1) map = argv[1];

    loadhexmap();
    loadpallete();
    cout << "Loading " << map << endl;

    BITMAP* bmp = load_bitmap(map.c_str(), NULL);
    if(bmp == NULL) {
        cout << "Map is null" << endl;
        return 1;
    }

    string raw = map.substr(0, map.length()-4) + ".raw";
    convert(bmp, raw);

    cout << "Done, press enter to exit" << endl;
    cin.ignore();
    return 0;
}

END_OF_MAIN();


/////////////
// rwk.txt //
/////////////

// Robot Wants Kitty original color chart
0 000000 // black - empty
1 117481 // blueish - left decor
2 17697f // blueish - right decor
3 f00005 // red - red badguy
4 fadf00 // yellowish - jump powerup
5 ff9d05 // orange - laser powerup
6 800000 // brown - ouch block
7 fa00df // pink - doublejump powerup
8 de8250 // light brown - jump jet powerup
9 b4de1c // greenish - dash rocket powerup
10 b0c5f0 // light blue - blue enemy
11 ff0b10 // red - red key
12 2aff05 // green - green key
13 0520ff // blue - blue key
14 db9de5 // pinkish purple - boss monster
15 f8ff1f // bright yellow - high-speed powerup
//
50 ffffff // white - solid wall
// note - giant blocks are placed automatically
//
55 db6d70 // reddish - red door
56 6dd65e // greenish - green door
57 627ed2 // blueish - blue door
//
254 00f40f // greenish - kitty
255 ff97ef // pinkish - robot