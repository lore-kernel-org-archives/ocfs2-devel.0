From: tristan <tristan.ye@oracle.com>
Date: Wed, 21 Apr 2010 09:40:34 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] Ocfs2: Add macro
 OCFS2_VOL_UUIDSTR_LEN in ocfs2_fs.h
In-Reply-To: <4BCE2F29.3060104@oracle.com>
References: <1271746743-17653-1-git-send-email-tristan.ye@oracle.com>	<20100420223223.GB9423@mail.oracle.com>
	<4BCE2C03.5000506@oracle.com> <4BCE2F29.3060104@oracle.com>
Message-ID: <4BCE5792.8010104@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Sunil Mushran wrote:
> ok. So how about we remove this #define totally and have
> the ioctl interface return the binary uuid. The o2info tool
> can convert do the conversion.

But... returning binary uuid from o2info was not that easy, ocfs2 
in-memory super_block osb only successfully initialized the osb->uuid, 
while did nothing to uuid_str, I remembered we've been discussing on 
that issue:

http://oss.oracle.com/pipermail/ocfs2-devel/2009-November/005514.html


That patch was not adopted, and we're still using uuid_str in most places.


Tristan.

>
> Sunil Mushran wrote:
>> True. I had asked Tristan to put it in ocfs2.h
>>
>> Joel Becker wrote:
>>> On Tue, Apr 20, 2010 at 02:59:02PM +0800, Tristan Ye wrote:
>>>> Since we've been using uuid_str in most of ocfs2 codes, adding
>>>> such a macro would be helpful.
>>>>
>>>> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
>>>> ---
>>>> fs/ocfs2/ocfs2_fs.h | 1 +
>>>> 1 files changed, 1 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
>>>> index bb37218..b313c83 100644
>>>> --- a/fs/ocfs2/ocfs2_fs.h
>>>> +++ b/fs/ocfs2/ocfs2_fs.h
>>>> @@ -274,6 +274,7 @@
>>>>
>>>> #define OCFS2_VOL_UUID_LEN 16
>>>> #define OCFS2_MAX_VOL_LABEL_LEN 64
>>>> +#define OCFS2_VOL_UUIDSTR_LEN (OCFS2_VOL_UUID_LEN * 2 + 1)
>>> Also, why is this in ocfs2_fs.h? It's not a structural
>>> feature.
>>>
>>> Joel
>>>
>>
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>
