From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Wed Dec 12 10:06:36 2007
Subject: [Ocfs2-devel] BTW: could some oracle people make
	the	oss.oracle.com website more faster?
In-Reply-To: <47601E9C.2050008@suse.de>
References: <91b13c310712120920k5898a260h6c859c1db4061940@mail.gmail.com>
	<47601E9C.2050008@suse.de>
Message-ID: <476022DD.10303@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

It's almost all text. One small image.

See if wget can help you pinpoint the problem.

$ wget -r -l1 http://oss.oracle.com/projects/ocfs2/
Run it in a temp dir.

Coly Li wrote:
> rae l wrote:
>   
>> On Dec 12, 2007 9:34 AM, Mark Fasheh <mark.fasheh@oracle.com> wrote:
>>     
>>> If pressed, I could think of even smaller patches someone could write which
>>> would make a positive impact on Ocfs2.
>>>         --Mark
>>>       
>> BTW: could some oracle people make the oss.oracle.com website more faster?
>>
>> Here I'm located in Shenzhen, China, this URL usually need 30 seconds
>> or more to access:
>> http://oss.oracle.com/projects/ocfs2/
>>
>> All URLs under http://oss.oracle.com/projects/ are slow, the exception
>> to that is: the wiki site is fast: http://oss.oracle.com/osswiki/OCFS2
>>
>> and I have checked my network environment: I use 2M ADSL at home and
>> 6M ADSL at work, other domestic and foreign websites can always be
>> loaded fast. so my network environment has no problem.
>>
>>     
> Maybe this is not issue of oracle website. It is slow in Beijing, too. But when I tried the
> connection from HK and Germany, the whole page can be displayed within 3 seconds.
> The ISP of mine in Beijing is a 2Mb ADSL from BBN, it seems website is fast enough, but connection
> is slow...
>
> Best regards.
>
>   
