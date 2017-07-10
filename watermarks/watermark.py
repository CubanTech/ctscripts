
import argparse
import itertools
import os
from PIL import Image
import sys

parser = argparse.ArgumentParser(description="Apply watermarks in batch mode to a set of images")

parser.add_argument('paths', metavar='PATH', nargs='+',
                    help='Image (folder) paths.')
parser.add_argument('-i', metavar='PATH', dest='input',
                    help='Path to watermark image')
parser.add_argument('-x', metavar='NUMBER', dest='x',
                    help='Horizontal offset to place watermark ... '
                         'from left (x > 0) or right (x < 0) border')
parser.add_argument('-y', metavar='NUMBER', dest='y',
                    help='Vertical offset to place watermark ... '
                         'from top (y > 0) or bottom (y < 0) border')
parser.add_argument('-o', metavar='PATH', dest='output', default='.',
                    help='Path to output folder')
#parser.add_argument('-w', metavar='INT', dest='width', default=0,
#                    help='Width of the sprite image')
#parser.add_argument('--scale', action='store_true',
#                    help='Scale images that do not fit in specified width. Will be ignored otherwise')

args = parser.parse_args()
args.x = int(args.x)
args.y = int(args.y)

watermark = None
try:
    watermark = Image.open(args.input)
except Exception, e:
    print(str(e))
    sys.exit(1)
winfo = { 'w' : watermark.size[0], 'h': watermark.size[1], 'mode' : watermark.mode }
print('Load watermark image %(mode)s %(w)s x %(h)s' % winfo)

paths = [(filename, os.path.join(path, filename)) for path in args.paths for filename in os.listdir(path)]

for file_name, img_path in paths:
    try:
        im = Image.open(img_path)
        size = im.size
        x = args.x if args.x > 0 else size[0] + args.x - winfo['w']
        y = args.y if args.y > 0 else size[1] + args.y - winfo['h']
        im.paste(watermark, (x, y), mask=watermark)
        im.save(os.path.join(args.output, file_name))
        try:
          im.close()
        except AttributeError:
          pass
    except KeyboardInterrupt, e:
        raise e
    except:
        print('Skipping : ' + file_name)

print('Done!')

