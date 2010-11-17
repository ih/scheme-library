#TO DO
#-get size of an image
#-compute the coordinates of an image w/in the animation based on its size and the animation size

import os, sys, Image, string
import cPickle as pickle

def y(y_large,y_small):
    return y_large-y_small
def x(x_large,x_small):
    assert((x_large-x_small)/2 >= 0)
    return (x_large-x_small)/2
def newCoord(large,small):
    x_large,y_large = large
    x_small,y_small = small
    return x(x_large,x_small),y(y_large,y_small)

def imageSizes(fname,num_of_images):
    return [imageSize(fname+str(i)+".png") for i in range(1,num_of_images+1)]

def imageSize(fname):
    return Image.open(fname).size

def makePage(coordinate, fname, index):
    return "-page +%d+%d %s%d.png" % (coordinate[0],coordinate[1],fname,index)

if __name__ == "__main__":
    fname,num_of_images = pickle.load(sys.stdin)
    print num_of_images
    sizes = imageSizes(fname,num_of_images)
    max_x = max([size[0] for size in sizes])
    max_y = max([size[1] for size in sizes])
    coordinates = [newCoord((max_x,max_y),size) for size in sizes]
    first_page = ["-page %dx%d" % (max_x,max_y)]
    pages = first_page+[makePage(coordinate, fname, coordinates.index(coordinate)+1) for coordinate in coordinates]
    pages = string.join(pages) 
    command = "convert -delay 100 "+pages+" -loop 0 "+fname+".gif"
    print command
    os.system(command)
#    os.system("convert -delay 100 -page 68x88 tree1.png -page tree2.png -page tree3.png -loop 0 anim_none.gif")
#    os.system("convert -delay 100 -loop 1 "+fname+"*.png "+fname+".gif")
#convert -delay 100 -page 68x88+13+47 tree1.png -page +6+31 tree2.png -page +0+16 tree3.png -page +0+0 tree4.png -loop 0 anim.gif

