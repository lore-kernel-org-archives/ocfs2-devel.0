From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Mar  3 16:30:10 2004
Subject: [Ocfs2-devel] Re: [PATCH]check return from ocfs_journal_wipe()
In-Reply-To: <200403032154.i23Ls9kU018323@penguin.co.intel.com>
References: <200403032154.i23Ls9kU018323@penguin.co.intel.com>
Message-ID: <20040303223006.GZ1421@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Mar 03, 2004 at 01:54:09PM -0800, Rusty Lynch wrote:
> I managed to get into a state on my 2.6 build where ocfs_journal_wipe()
> failed, and then because we were not checking the return status of the
> the function, the journal_load() in ocfs_journal_load() called BUG.
> 
> Here is a quick patch that should catch such a problem by bailing
> when an error is detected.
Good catch. Any idea what the error (or error #) was? I'd like to know what
you hit...
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
