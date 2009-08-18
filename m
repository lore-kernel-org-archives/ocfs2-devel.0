From: David Teigland <teigland@redhat.com>
Date: Tue, 18 Aug 2009 14:34:10 -0500
Subject: [Ocfs2-devel] dlm stress test hangs OCFS2
In-Reply-To: <4A8B0083.8030400@suse.de>
References: <4A8B0083.8030400@suse.de>
Message-ID: <20090818193410.GA6221@redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Aug 19, 2009 at 03:26:59AM +0800, Coly Li wrote:
> When I add more printk inside the code, the blocking will very hard to
> reproduce. Therefore, I suspect there is kind of race inside.
> 
> I work on this issue for quite many days, still no idea how this issue comes
> and how to fix it. Many people here might know this issue already, wish
> upstream developers can watch on it and provide hints on the fix.

I've tried to dig into this a couple of times, and each time get stopped
trying to sort out the dlmglue.c logic; I think that's where the problem lies.

Dave
