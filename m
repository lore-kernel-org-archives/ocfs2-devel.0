From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Mar 17 19:09:20 2004
Subject: [Ocfs2-devel] Re: Is oin->needs_flush_list just dead code??
In-Reply-To: <032EB457B9DBC540BFB1B7B519C78B0E0385367E@orsmsx404.jf.intel.com>
References: <032EB457B9DBC540BFB1B7B519C78B0E0385367E@orsmsx404.jf.intel.com>
Message-ID: <20040318010915.GM20057@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Mar 17, 2004 at 04:01:36PM -0800, Lynch, Rusty wrote:
> In ocfs_release_cached_oin(), there is some logic that will empty oin->
> needs_flush_list and set oin->ins_needs_flush_list to false, but there is no
> code that actually adds entries to this list.  Is this just dead code?
heh, looks like it :)
If you take a look at the TODO list, you'll notice that I added this entry a
day or two ago:

* Move the last of the used, non redundant fields off the oin and put them
  on the inode in our private data area. This should have the nice effect of
  getting rid of oin.

Anything you could do (*cough* submit a patch *cough*) to further that goal
would be much appreciated :)

There's actually a fair amount of dead code / unused fields in general that
could be cleaned up.
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
