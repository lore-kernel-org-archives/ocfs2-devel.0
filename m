From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Mar 11 19:21:23 2004
Subject: [Ocfs2-devel] Re: [PATCH]2.6 fix for revalidating an inode
In-Reply-To: <200403112259.i2BMxnsZ008760@penguin.co.intel.com>
References: <200403112259.i2BMxnsZ008760@penguin.co.intel.com>
Message-ID: <20040312012120.GE7836@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Mar 11, 2004 at 02:59:49PM -0800, Rusty Lynch wrote:
> The following minimal patch catches the case on a 2.6 system where
> the passed in nameidata is null (which is a valid scenario.)
> 
> This is what is causing file deletion to crash.
Ok, that one was easy to commit :)
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
