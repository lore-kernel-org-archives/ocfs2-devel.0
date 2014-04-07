From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 7 Apr 2014 14:52:42 +1000
Subject: [Ocfs2-devel] linux-next: build failure after merge of the final
	tree
Message-ID: <20140407145242.1958251349e0b6c6c8923f46@canb.auug.org.au>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, Linus <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

fs/ocfs2/suballoc.c: In function 'ocfs2_block_group_set_bits':
fs/ocfs2/suballoc.c:1357:2: error: implicit declaration of function 'trace_ocfs2_block_group_set_bits' [-Werror=implicit-function-declaration]
  trace_ocfs2_block_group_set_bits(bit_off, num_bits);
  ^

I have no idea how to track this down :-( The only patches affecting this
code are now in Linus' tree.  I can only assume that some implicitly
included header file is no longer included.  I have just left it broken
for now.

-- 
Cheers,
Stephen Rothwell                    sfr at canb.auug.org.au
-------------- next part --------------
A non-text attachment was scrubbed...
Name: not available
Type: application/pgp-signature
Size: 836 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20140407/9ea969f6/attachment-0001.bin 
