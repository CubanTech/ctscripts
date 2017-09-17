
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
                         'from left (NUMBER > 0) or right (NUMBER < 0) border')
parser.add_argument('-y', metavar='NUMBER', dest='y',
                    help='Vertical offset to place watermark ... '
                         'from top (NUMBER > 0) or bottom (NUMBER < 0) border')
parser.add_argument('--top', metavar='NUMBER', dest='top', default=None,
                    help='Crop image at the top')
parser.add_argument('--bottom', metavar='NUMBER', dest='bottom', default=None,
                    help='Crop image at the bottom')
parser.add_argument('--left', metavar='NUMBER', dest='left', default=None,
                    help='Crop image at the left')
parser.add_argument('--right', metavar='NUMBER', dest='right', default=None,
                    help='Crop image at the right')
parser.add_argument('-o', metavar='PATH', dest='output', default='.',
                    help='Path to output folder')
#parser.add_argument('-w', metavar='INT', dest='width', default=0,
#                    help='Width of the sprite image')
#parser.add_argument('--scale', action='store_true',
#                    help='Scale images that do not fit in specified width. Will be ignored otherwise')

args = parser.parse_args()
try:
    args.x = int(args.x)
    args.y = int(args.y)
except ValueError:
    sys.exit('Integer values expected for -x and -y CLI arguments')

watermark = None
try:
    watermark = Image.open(args.input)
except Exception, e:
    print(str(e))
    sys.exit(1)
winfo = { 'w' : watermark.size[0], 'h': watermark.size[1], 'mode' : watermark.mode }
print('Load watermark image %(mode)s %(w)s x %(h)s' % winfo)

paths = [(filename, os.path.join(path, filename)) for path in args.paths for filename in os.listdir(path)]

BORDERS = ('left', 'right', 'top', 'bottom')
do_crop = any(getattr(args, dim) is not None for dim in BORDERS)
if do_crop:
    try:
        for b in BORDERS:
            value = getattr(args, b)
            if value is not None:
                setattr(args, b, int(value)) 
    except:
        sys.exit('Integer values expected for --left --right --top --bottom CLI arguments')
        # TODO: exit
        do_crop = False

for file_name, img_path in paths:
    _im = None
    try:
        im = Image.open(img_path)
        size = im.size
        if do_crop:
            left = 0 if args.left is None else args.left if args.left > 0 else size[0] + args.left
            right = size[0] if args.right is None else args.right if args.right > 0 else size[0] + args.right
            if right < left:
                right, left = left,right
            top = 0 if args.top is None else args.top if args.top > 0 else size[1] + args.top
            bottom = size[1] if args.bottom is None else args.bottom if args.bottom > 0 else size[1] + args.bottom
            if bottom < top:
                bottom, top = top, bottom
            _im = im
            im = _im.crop((left, top, right, bottom))
            size = im.size
        x = args.x if args.x > 0 else size[0] + args.x - winfo['w']
        y = args.y if args.y > 0 else size[1] + args.y - winfo['h']
        im.paste(watermark, (x, y), mask=watermark)
        im.save(os.path.join(args.output, file_name))
        try:
          im.close()
          if _im is not None:
              _im.close()
        except AttributeError:
          pass
    except KeyboardInterrupt, e:
        raise e
    except:
        print('Skipping : ' + file_name)

print('Done!')

