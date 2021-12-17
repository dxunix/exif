import exif


def show_image_date(filename: str):
"""
    method to display image info
"""
    with open(filename, 'rb') as image_file:
        image = exif.Image(image_file)
    dir(iamge)

