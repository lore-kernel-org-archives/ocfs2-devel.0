From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Mar 23 19:55:35 2004
Subject: [Ocfs2-devel] Re: [CRASH]Oops in journal_wip on first mount
In-Reply-To: <200403240138.i2O1cm5n013594@penguin.co.intel.com>
References: <200403240138.i2O1cm5n013594@penguin.co.intel.com>
Message-ID: <20040324015530.GD10672@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Mar 23, 2004 at 05:38:48PM -0800, Rusty Lynch wrote:
> I am seeing the following crash on my 2.4 build as of the latest svn tree.
> (I have not tried to check-out an older tree to see if this goes away.)
> 
> I see this on a 2.4.22 kernel while attempting to mount a volume for the 
> first time.  My mount segfaults, leaving some crud behind...
Are you sure this is a first mount? We're not supposed to be calling
journal_wipe on 1st mount...

Or is it a file system which failed the 1st mount and this is your second go
at a 1st mount?
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
