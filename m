From: Coly Li <coly.li@suse.de>
Date: Fri, 17 Apr 2009 19:17:50 +0800
Subject: [Ocfs2-devel] hang with fsdlm
In-Reply-To: <49E692D7.5030009@oracle.com>
References: <20090415165717.GD22705@redhat.com> <49E692D7.5030009@oracle.com>
Message-ID: <49E8655E.1090403@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Sunil Mushran Wrote:
> David,
> 
> So it's the same issue. bull-02 knows it is blocking an EX, has no
> holders, but is not doing anything to downconvert.
> 
> Coly Li is working on this same issue on novellbz#492055.
> https://bugzilla.novell.com/show_bug.cgi?id=492055
> 
> He is unable to reproduce with the sles11 kernel. The dlm bits should
> be the same as mainline. I think. I've asked him to run with mainline.
> 
I setup a 4 nodes cluster with 2.6.30rc2 upstream kernel. Wish David's
suggestion, I create a new ocfs2 volume, it's quite easy to reproduce this issue
by running make_panic within 5 seconds.

Continue to track down.

-- 
Coly Li
SuSE Labs
