import csv
import json
import requests

# TODO: HTML->BBCode for Rich text markup in Godot

# Load common headings
with open('common_headings.csv', 'r') as readfile:
    csvreader = csv.reader(readfile)
    common_headings = [x[0] for x in csvreader]

# Do API stuff

language = 'en'

section_api = "https://{lang}.wikipedia.org/w/api.php?action=parse&format=json&page={page_title}&prop=sections"

BORING_TITLES = [
    'See also',
    'References',
    'External links',
    'Notes'
]


def get_unique_page(num_pages):
    random_pages_url = "https://{lang}.wikipedia.org/w/api.php?action=query&format=json&list=random&rnnamespace=0&rnlimit={num_pages}".format(
        lang=language,
        num_pages=num_pages
    )

    r = requests.get(random_pages_url)
    random_pages = r.json()
    random_pages_list = random_pages['query']['random']

    page_outputs = {}
    for page in random_pages_list:
        page_title = page['title']

        headings = get_page_headings(page_title)
        if headings:
            num_unique_headings = 0
            num_headings = len(headings)
            if 4 < num_headings < 9:
                for heading in headings:
                    if heading not in common_headings:
                        num_unique_headings += 1

                # Score - primarily fraction of unique headings, but give preference to larger number of sections
                fraction_unique_headings = num_unique_headings/num_headings
                page_outputs[page_title] = fraction_unique_headings + (num_unique_headings * 0.03)

    # Only send this if we found more than 2 viable pages
    if len(page_outputs) > 2:
        most_unique_page = max(page_outputs, key=page_outputs.get)
        return most_unique_page
    else:
        return None


def get_page_headings(page_title):
    r = requests.get(section_api.format(
        lang=language,
        page_title=page_title
    ))

    page_json = r.json()

    try:
        sections = page_json['parse']['sections']
    except KeyError:
        return False

    titles = [x['line'] for x in sections if 'line' in x and x['line'] not in BORING_TITLES]
    return titles


def seed_initial_list(num_entries):
    with open('interesting_pages.json', 'w', encoding='utf-8') as outfile:
        interesting_pages = {}
        for i in range(num_entries):
            unique_page = get_unique_page(25)
            page_headings = get_page_headings(unique_page)

            if unique_page and page_headings:
                interesting_pages[unique_page] = page_headings

        json.dump(interesting_pages, outfile, ensure_ascii=False)


seed_initial_list(30)
