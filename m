From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 03 Sep 2008 10:02:48 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: clean up ocfs2_journal_dirty mess
	in xattr.c
In-Reply-To: <20080903012748.GD4563@wotan.suse.de>
References: <1220208013-5682-1-git-send-email-tao.ma@oracle.com>
	<20080903012748.GD4563@wotan.suse.de>
Message-ID: <48BDF048.1010903@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Mark Fasheh wrote:
> On Mon, Sep 01, 2008 at 02:40:13AM +0800, Tao Ma wrote:
>> In xattr.c, ocfs2_journal_dirty is called in many places, but they
>> are quite a mess, some are called with their return value checked,
>> some are not and in ocfs2_half_xattr_bucket there is even a bug which
>> we don't set the return value while checking  it. So this patch go
>> through all the places we call ocfs2_journal_dirty and add the check
>> for return value.
> 
> Actually, if you look at the core functions involved
> (journal_dirty_metadata), they never return error. This makes sense - how
> would one unroll changes made to a buffer at the point of journal_dirty?
> At some time in the future, I plan to just make ocfs2_journal_dirty() a void
> function so that it "feels right" not checking for error.
ok,  that would be cool.
Thanks.

Regards,
Tao
