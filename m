From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Feb 17 17:09:37 2004
Subject: [Ocfs2-devel] Re: Whats missing in mkfs?
In-Reply-To: <200402172220.i1HMKv24008615@penguin.co.intel.com>
References: <200402172220.i1HMKv24008615@penguin.co.intel.com>
Message-ID: <20040217230932.GL26331@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

There's a couple of things:

We need to create and format the journal files. They should be 8 megs in
size, and default to just creating journals for nodes 1-4. Basically what
mkfs for an ext3 filesystem does. Also, the local alloc bitmap structures
need to be created as well (one for each node). If you look at the calls to
ocfs_journal_init (the exend_system_file call there) and ocfs_journal_create
and ocfs_create_new_local_alloc in ocfs_check_volume, you'll see what i
mean. Also, ocfs does a ton of other things in terms of initializing system
files to the filesystem on "1st mount" which really should be moved into the
format utility. Check out ocfs_create_root_dir_node for that.

Essentially, we're doing a *ton* of stuff in kernel space, which really
should be in userspace. If you're interested in tackling this, I'd be more
than happy to coordinate :)
	--Mark

On Tue, Feb 17, 2004 at 02:20:57PM -0800, Rusty Lynch wrote:
> The TODO list has an item about finishing mkfs.
> It looks like mkfs -t ocfs2 works fine.  Is there 
> something specific that is missing
> 
>     --rusty
--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
