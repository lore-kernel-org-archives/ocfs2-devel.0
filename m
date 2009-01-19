From: Coly Li <coly.li@suse.de>
Date: Mon, 19 Jan 2009 13:48:03 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: return f_fsid info in
	ocfs2_statfs(), v4
In-Reply-To: <9E89783A-53C8-4999-9DD2-57237A03E1A2@oracle.com>
References: <49704641.1010005@suse.de>
	<D9BD94CC-31A4-446D-A331-12CA8A5BD46D@oracle.com>
	<4973E2E3.2030106@suse.de>
	<9E89783A-53C8-4999-9DD2-57237A03E1A2@oracle.com>
Message-ID: <49741413.2040307@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Sunil Mushran Wrote:
> Yeah... I was wrong. This should work.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> 
Thanks for your review and SOB :)

> 
> On Jan 18, 2009, at 6:18 PM, Coly Li <coly.li@suse.de> wrote:
> 
>>
>>
>> Sunil Mushran Wrote:
>>> f_fsid.val[1] look wrong. Just set it to zero.
>>>
>> It's OK to set it to zero. But can you please to explain a little bit
>> why f_fsid.val[1] is wrong ?
>> I tested the code and the f_fsid.val looked well.
>>
>> Thanks for the review.
>>
>>> On Jan 16, 2009, at 12:33 AM, Coly Li <coly.li@suse.de> wrote:
>>>

-- 
Coly Li
SuSE Labs
