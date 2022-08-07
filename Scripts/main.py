import csv
import requests

language = "en"
num_pages = 500

section_api = "https://{lang}.wikipedia.org/w/api.php?action=parse&format=json&page={page_title}&prop=sections"

random_pages_url = "https://{lang}.wikipedia.org/w/api.php?action=query&format=json&list=random&rnnamespace=0&rnlimit={num_pages}".format(
    lang=language,
    num_pages=num_pages
)

random_pages_list = []
for i in range(20):
    r = requests.get(random_pages_url)
    random_pages = r.json()
    random_pages_list.extend(random_pages['query']['random'])

title_tracking = {}

title_avoid_strings = [
    '<span',
    '<class',
    '<href'
]


def avoid_page(titles_to_check):
    for title_check in titles_to_check:
        for avoided_string in title_avoid_strings:
            if avoided_string in title_check:
                return True

    return False


for i, page in enumerate(random_pages_list):
    page_title = page['title']

    r = requests.get(section_api.format(
        lang=language,
        page_title=page_title
    ))

    page_json = r.json()

    try:
        sections = page_json['parse']['sections']
    except KeyError:
        continue

    titles = [x['line'] for x in sections if 'line' in x]
    if 3 < len(titles) < 8:
        if avoid_page(titles):  # Avoid some weird headings, e.g. HTML
            continue
        else:
            for title in titles:
                if title not in title_tracking:
                    title_tracking[title] = 1
                else:
                    title_tracking[title] += 1

    if (i+1) % 100 == 0:
        print(i+1)

sorted_output = {k: v for k, v in sorted(title_tracking.items(), key=lambda item: item[1], reverse=True)}

with open('common_headings.csv', 'w', newline='', encoding='utf-8') as outfile:
    output_writer = csv.writer(outfile)
    output_writer.writerow(['Section', 'Count'])
    for key, count in sorted_output.items():
        if count > 1:
            output_writer.writerow([key, count])
