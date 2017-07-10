
import argparse
import itertools
import os
from PIL import Image
import sys

parser = argparse.ArgumentParser(description="Bundle some images in a single sprite and generate CSS styles")

parser.add_argument('paths', metavar='PATH', nargs='+',
                    help='Image (folder) paths.')
parser.add_argument('--prefix', metavar='TEXT', default='sprite',
                    help='Prefix CCS class names with given TEXT')
parser.add_argument('-o', metavar='PATH', dest='output', default='.',
                    help='Path to output folder')
#parser.add_argument('-w', metavar='INT', dest='width', default=0,
#                    help='Width of the sprite image')
#parser.add_argument('--scale', action='store_true',
#                    help='Scale images that do not fit in specified width. Will be ignored otherwise')

args = parser.parse_args()

paths = [(os.path.splitext(filename)[0], os.path.join(path, filename)) for path in args.paths for filename in os.listdir(path)]
width, vdiff = Image.open(paths[0][1]).size

css_code = """
.%(c)s { background: url('sprite.png') no-repeat top left; width: %(w)spx; height: %(h)spx; }
""" % dict(c=args.prefix, w=width, h=vdiff)

vdiff += 5
sprite = Image.new('RGBA', (width, len(paths) * vdiff), (0, 0, 0, 255))
pos = 0

for cls, img_path in paths:
  im = Image.open(img_path)
  sprite.paste(im, (0, pos))
  try:
    im.close()
  except AttributeError:
    pass
  css_code += '.%(g)s.%(g)s-%(s)s { background-position: 0 -%(p)spx; } \n' % dict(
        g=args.prefix, s=cls, p=pos)
  pos += vdiff

with open(os.path.join(args.output, 'sprite.css'), 'w') as f:
  f.write(css_code)
  sprite.save(os.path.join(args.output, 'sprite.png'))


