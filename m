From: Tristan Ye <tristan.ye@oracle.com>
Date: Fri, 28 Jan 2011 09:43:24 +0800
Subject: [Ocfs2-devel] [PATCH 01/14] Ocfs2/refcounttree: Fix a bug for
 refcounttree to writeback clusters in a right number.
In-Reply-To: <20110127232923.GB23899@wotan.suse.de>
References: <1295605231-15991-1-git-send-email-tristan.ye@oracle.com>
	<1295605231-15991-2-git-send-email-tristan.ye@oracle.com>
	<20110127232923.GB23899@wotan.suse.de>
Message-ID: <4D421F3C.9010109@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mark Fasheh wrote:
> On Fri, Jan 21, 2011 at 06:20:18PM +0800, Tristan Ye wrote:
>> Current refcounttree codes actually didn't writeback the new pages out in
>> write-back mode, due to a bug of always passing a ZERO number of clusters
>> to 'ocfs2_cow_sync_writeback', the patch tries to pass a proper one in.
>>
>> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
>
> Seems to look reasonable to me, though Joel or Tao might want to give their
> own quick SOB too.

Mark,

    Thanks for your quick review;-)

>
> Joel: I think we want this particular patch to go upstream sooner than
> later, yes?

Yep, it's more like a stand-alone fix for reflink than one part of 
defragmentation patches.

It thus will be better to have this in next 'fixes' commit.


Tristan.

>
> Signed-off-by: Mark Fasheh <mfasheh@suse.com>
> 	--Mark
>
> --
> Mark Fasheh
