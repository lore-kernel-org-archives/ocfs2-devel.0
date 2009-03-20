From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 20 Mar 2009 08:45:47 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix 2 warning during ocfs2 make.
In-Reply-To: <20090320003846.GD13065@wotan.suse.de>
References: <1237410523-8639-1-git-send-email-tao.ma@oracle.com>
	<20090320003846.GD13065@wotan.suse.de>
Message-ID: <49C2E73B.3000909@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Mark,
	I saw this in your upstream-merge_window. And I compared it with your 
merge_window, the upstream one has more patches than the other, it looks 
like the branch you mentioned in "Ocfs2 updates for 2.6.30". The bug is 
found there.

Regards,
Tao

Mark Fasheh wrote:
> On Thu, Mar 19, 2009 at 05:08:43AM +0800, Tao Ma wrote:
>> fs/ocfs2/dir.c: In function ?ocfs2_extend_dir?:
>> fs/ocfs2/dir.c:2700: warning: ?ret? may be used uninitialized in this function
>>
>> fs/ocfs2/suballoc.c: In function ?ocfs2_get_suballoc_slot_bit?:
>> fs/ocfs2/suballoc.c:2216: warning: comparison is always true due to limited range of data type
> 
> Does the 2nd bug still exist in merge_window? I didn't see it, so I just
> merged the 1st one into merge_window.
> 	--Mark
> 
> 
> --
> Mark Fasheh
