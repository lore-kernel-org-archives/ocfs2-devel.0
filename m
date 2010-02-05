From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 05 Feb 2010 15:37:11 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Plugs race between the dc thread
 and an unlock ast message
In-Reply-To: <20100205193313.GG11402@wotan.suse.de>
References: <1265221014-10591-1-git-send-email-sunil.mushran@oracle.com>
	<20100204102729.GA4339@laptop.oracle.com>
	<4B6B21BE.10708@oracle.com> <20100205060148.GA3416@mail.oracle.com>
	<4B6C65F3.8000805@oracle.com>
	<20100205193313.GG11402@wotan.suse.de>
Message-ID: <4B6CABA7.4020502@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mark Fasheh wrote:
> I really want to say that we should prevent those two threads from racing in
> the first place. How to do that though might be problematic. I'm not sure
> simply spinning on OCFS2_LOCK_QUEUED might not be enough - that flag gets
> cleared before the ->post_unlock callback...

David,

Please could you rerun with the following debug patch.

http://oss.oracle.com/~smushran/.dlmglue/0001-ocfs2-Patch-to-debug-hang-in-dlmglue-when-running-dl.patch

May make sense to fire it either later in the day or fire mlocate
a shortwhile after starting the test. That's to reduce the trace logs.

Thanks
Sunil
