From: tristan <tristan.ye@oracle.com>
Date: Wed, 21 Apr 2010 09:37:45 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] Ocfs2: Add macro
 OCFS2_VOL_UUIDSTR_LEN in ocfs2_fs.h
In-Reply-To: <4BCE2C03.5000506@oracle.com>
References: <1271746743-17653-1-git-send-email-tristan.ye@oracle.com>
	<20100420223223.GB9423@mail.oracle.com>
	<4BCE2C03.5000506@oracle.com>
Message-ID: <4BCE56E9.9@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Sunil Mushran wrote:
> True. I had asked Tristan to put it in ocfs2.h
>
> Joel Becker wrote:
>> On Tue, Apr 20, 2010 at 02:59:02PM +0800, Tristan Ye wrote:
>>> Since we've been using uuid_str in most of ocfs2 codes, adding
>>> such a macro would be helpful.
>>>
>>> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
>>> ---
>>> fs/ocfs2/ocfs2_fs.h | 1 +
>>> 1 files changed, 1 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
>>> index bb37218..b313c83 100644
>>> --- a/fs/ocfs2/ocfs2_fs.h
>>> +++ b/fs/ocfs2/ocfs2_fs.h
>>> @@ -274,6 +274,7 @@
>>>
>>> #define ' 16
>>> #define OCFS2_MAX_VOL_LABEL_LEN 64
>>> +#define OCFS2_VOL_UUIDSTR_LEN (OCFS2_VOL_UUID_LEN * 2 + 1)
>>
>> Also, why is this in ocfs2_fs.h? It's not a structural
>> feature.

Yes I remembered sunil has asked me to add this in ocfs2.h, that's 
really my fault.

I thought it should be together with 'OCFS2_VOL_UUID_LEN', that's 
definitely wrong.


>>
>> Joel
>>
>
