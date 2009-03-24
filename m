From: Greg KH <greg@kroah.com>
Date: Tue, 24 Mar 2009 00:16:08 -0000
Subject: [Ocfs2-devel] [stable] Linux 2.6.28.8 (ocfs2 build failure)
In-Reply-To: <20090323024404.GA14082@mit.edu>
References: <20090317012028.GA32410@kroah.com> <49C00787.6060401@oracle.com>
	<20090317205518.GA4442@kroah.com> <49C00FE9.9040407@oracle.com>
	<20090320221750.GA32416@kroah.com> <20090323024404.GA14082@mit.edu>
Message-ID: <20090324001325.GA1909@kroah.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>, Randy Dunlap <randy.dunlap@oracle.com>, Jan Kara <jack@suse.cz>, Greg KH <gregkh@suse.de>, mfasheh@suse.com, Andrew Morton <akpm@linux-foundation.org>

On Sun, Mar 22, 2009 at 10:44:04PM -0400, Theodore Tso wrote:
> On Fri, Mar 20, 2009 at 03:17:50PM -0700, Greg KH wrote:
> > 
> > I tracked this down to commit 54dc90 in the 2.6.28.8 tree.
> > 
> > I've included it below.  Jan and Ted, any ideas on how to fix this
> > error?
> 
> 2.6.29 dropped the CONFIG_OCFS2_COMPAT_JBD option; if you enable it,
> causes a compile failure in 2.6.28.8.  This should fix it...

Can you send it in a format that I can apply it in?

thanks,

greg k-h
