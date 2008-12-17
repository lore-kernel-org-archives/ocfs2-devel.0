From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 17 Dec 2008 08:19:57 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Always update xattr search when
	creating bucket.
In-Reply-To: <20081216214012.GY8791@wotan.suse.de>
References: <1228439650-5101-1-git-send-email-tao.ma@oracle.com>
	<20081216214012.GY8791@wotan.suse.de>
Message-ID: <494845AD.4060309@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Mark Fasheh wrote:
> On Fri, Dec 05, 2008 at 09:14:10AM +0800, Tao Ma wrote:
>> When we create xattr bucket during the process of xattr set, we always
>> need to update the ocfs2_xattr_search since even if the bucket size is
>> the same as block size, the offset will change because of the removal
>> of the ocfs2_xattr_block header.
> 
> Ok, this is in the fixes branch now. I will send it upstream tommorrow. By
> the way - am I correct in that merge_window seems to have fixed this
> already?
no, and AFAICS, there is a minor merge conflict with the merge window 
because of Joel's refactoring of xattr buckets, but it can be easily 
resolved. ;)

Regards,
Tao
