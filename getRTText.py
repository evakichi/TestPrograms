import sys
import time
import ujson
import hashlib
import urllib.request
from selenium.webdriver import Chrome, ChromeOptions
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By


def load_table(element):
    meta = element.find_element(By.CLASS_NAME,"metadata")
    date = meta.find_element(By.CLASS_NAME,"date")
    messagebody = element.find_element(By.CLASS_NAME,"messagebody")
    try:
        messagestanza = messagebody.find_element(By.CLASS_NAME,"message-stanza")
        h=hashlib.sha256(driver.title.encode('utf-8')+messagestanza.text.encode('utf-8')).hexdigest()
        string = '[\n {\n' + '"_key"' + ':' + '"'+ h  +'"' + ',\n"CreateDate"' + ":" + '"'  +date.text + '",\n"Subject"' + ':'+ ujson.dumps(driver.title) + ',\n' + '"Text"' + ':'+ ujson.dumps(messagestanza.text) +'\n},\n]\n'
    except:
        h=hashlib.sha256(driver.title.encode('utf-8')).hexdigest()
        string = '[\n {\n' + '"_key"' + ':' + '"'+ h  +'"' + ',\n"CreateDate"' + ":" + '"'  +date.text + '",\n"Subject"' + ':'+ ujson.dumps(driver.title) + ',\n' + '"Text"' + ':'+ ujson.dumps("") +'\n},\n]\n'
    headers = {
    'Content-Type': 'application/json',
    }
    post_url = 'http://localhost/d/load'
    post_table = "RTLogs"
    req = urllib.request.Request("http://localhost/d/load?table=RTLogs",string.encode(),headers)
    with urllib.request.urlopen(req) as res:
        body = res.read()
    #print('{\n' + '"_key"' + ':' + '"'+ h  +'"' + ',\n"CreateDate"' + ":" + '"'  +date.text + '",\n"Subject"' + ':'+ ujson.dumps(driver.title) + ',\n' + '"Text"' + ':'+ ujson.dumps(messagestanza.text) +'\n},\n')

url="https://mdpf-support.nims.go.jp/tickets/"

options = ChromeOptions()
options.add_argument('--headless')
driver = Chrome(options=options)

driver.get(url)

id = driver.find_element_by_id("user")
id.send_keys("ISHIHARA.Makoto@nims.go.jp")
password = driver.find_element_by_name("pass")
password.send_keys("SRxM057%")
password.send_keys(Keys.ENTER)

global_count = 0 
for i in range(16,51):
    url="https://mdpf-support.nims.go.jp/tickets/Ticket/Display.html?id="+str(i)
    driver.get(url)
    driver.execute_script("return (jQuery || { active: 0 }).active")
    time.sleep(5)

    print(driver.title,file=sys.stderr,end="  ")

    container  = driver.find_element(By.CLASS_NAME,"history-container")
    odd  = container.find_elements_by_xpath('//div[@class="transaction Ticket-transaction message odd"]')
    even  = container.find_elements_by_xpath('//div[@class="transaction Ticket-transaction message even"]')


    local_count = len(odd)+len(even)
    global_count += local_count

    print(" count:"+str(local_count) + " total:" + str(global_count),file=sys.stderr)

    for o in odd:
        load_table(o)

    for e in even:
        load_table(e)
