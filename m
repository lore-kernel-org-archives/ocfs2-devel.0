From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Wed Mar  3 17:15:24 2004
Subject: [Ocfs2-devel] Re: [PATCH]check return from ocfs_journal_wipe()
In-Reply-To: <20040303223006.GZ1421@ca-server1.us.oracle.com>
References: <200403032154.i23Ls9kU018323@penguin.co.intel.com>
	<20040303223006.GZ1421@ca-server1.us.oracle.com>
Message-ID: <20040303223625.GA18418@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Mar 03, 2004 at 02:30:06PM -0800, Mark Fasheh wrote:
> On Wed, Mar 03, 2004 at 01:54:09PM -0800, Rusty Lynch wrote:
> > I managed to get into a state on my 2.6 build where ocfs_journal_wipe()
> > failed, and then because we were not checking the return status of the
> > the function, the journal_load() in ocfs_journal_load() called BUG.
> > 
> > Here is a quick patch that should catch such a problem by bailing
> > when an error is detected.
> Good catch. Any idea what the error (or error #) was? I'd like to know what
> you hit...
> 	--Mark

It returned -22.  Here is a dump of the last page debug messages:

(13552) ENTRY: ocfs_update_extent_map() 
(13552) ENTRY: ocfs_add_extent_map_entry() 
(13552) ENTRY: ocfs_extent_map_add() 
(13552) ENTRY: ocfs_coalesce_extent_map_entry() 
(13552) EXIT : ocfs_coalesce_extent_map_entry() = 0 
(13552) EXIT : ocfs_extent_map_add() = 1 
(13552) EXIT : ocfs_add_extent_map_entry() = 1 
(13552) EXIT : ocfs_update_extent_map() = 0 
(13552) ENTRY: ocfs_lookup_extent_map_entry() 
(13552) ENTRY: ocfs_extent_map_lookup() 
(13552) EXIT : ocfs_extent_map_lookup() = 1 
(13552) EXIT : ocfs_lookup_extent_map_entry() = 1 
(13552) EXIT : ocfs_lookup_file_allocation() = 0 
(13552) EXIT : ocfs_bmap() = 7024 
(13552) TRACE: ocfs_journal_init() k_journal->j_maxlen = 16384
(13552) EXIT : ocfs_journal_init() = 0 
(13552) TRACE: ocfs_check_volume() Node config states a journal version of 1
(13552) ENTRY: ocfs_journal_wipe() 
JBD: no valid journal superblock found
(13552) EXIT : ocfs_journal_wipe() = -22 
(13552) ENTRY: ocfs_journal_load() 
Assertion failure in journal_get_superblock() at fs/jbd/journal.c:935: "bh != NULL"
------------[ cut here ]------------
kernel BUG at fs/jbd/journal.c:935!
invalid operand: 0000 [#1]
CPU:    0
EIP:    0060:[<c018c220>]    Not tainted VLI
EFLAGS: 00010286
EIP is at journal_get_superblock+0x130/0x140
eax: 00000057   ebx: d7816b60   ecx: c0341890   edx: 00000000
esi: fffffffb   edi: da11a000   ebp: d9b87cbc   esp: d9b87c9c
ds: 007b   es: 007b   ss: 0068
Process mount (pid: 13552, threadinfo=d9b86000 task=d69bad00)
Stack: c0301a40 c02eff49 c02fea43 000003a7 c02fe946 00000000 d7816b60 e08dbddf 
       d9b87ccc c018c244 d7816b60 d7816b60 d9b87cdc c018c2a4 d7816b60 da11a7c0 
       d9b87cfc e08af363 d7816b60 000034f0 e08dbddf e08ddbf9 da11a7c0 00000000 
Call Trace:
 [<c018c244>] load_superblock+0x14/0x60
 [<c018c2a4>] journal_load+0x14/0xa0
 [<e08af363>] ocfs_journal_load+0x73/0x1c0 [ocfs2]
 [<e08b3c67>] ocfs_check_volume+0x537/0x600 [ocfs2]
 [<e08a0e0c>] ocfs_mount_volume+0x66c/0xd20 [ocfs2]
 [<c0115b90>] default_wake_function+0x0/0x20
 [<c0115b90>] default_wake_function+0x0/0x20
 [<c0115b90>] default_wake_function+0x0/0x20
 [<c0115b90>] default_wake_function+0x0/0x20
 [<e08dace0>] ocfs_timeout_func+0x0/0x20 [ocfs2]
 [<c0150224>] sb_set_blocksize+0x24/0x60
