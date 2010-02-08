From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 8 Feb 2010 12:59:00 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Treat ocfs2 truncate as a
 special case of punching holes v1.
In-Reply-To: <4B6F6C90.9010002@oracle.com>
References: <1264148107-9341-1-git-send-email-tristan.ye@oracle.com>
	<4B5CFE12.9010503@oracle.com> <4B5ED495.60001@oracle.com>
	<20100205231419.GD3416@mail.oracle.com>
	<4B6F6C90.9010002@oracle.com>
Message-ID: <20100208205900.GB1832@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Feb 08, 2010 at 09:44:48AM +0800, tristan wrote:
> 0.00user 0.35system 0:00.52elapsed 67%CPU,   while new logic (using ocfs2_remove_btree_range) from begin to end should be:
> 
> 
> 0.00user 33.06system 0:33.11elapsed 99%CPU.

	Ok, so original truncate is .52s, remove_btree from begin-to-end
is 33s, and remove_btree from end-to-begin is 1.16s.  begin-to-end is a
disaster, but end-to-begin is less than half a second longer than the
original code.  That's perfectly fine, given the cleanup we get in the
code.

Thanks!
Joel

-- 

Life's Little Instruction Book #356

	"Be there when people need you."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
