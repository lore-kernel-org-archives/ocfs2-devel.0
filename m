From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 11 Oct 2010 13:47:17 -0700
Subject: [Ocfs2-devel] [PATCH] /fs/ocfs2/slot_map.c (2.6.35.6):
	Uninitialized variable
In-Reply-To: <28389.94142.qm@web45810.mail.sp1.yahoo.com>
References: <28389.94142.qm@web45810.mail.sp1.yahoo.com>
Message-ID: <20101011204717.GD4255@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Sep 27, 2010 at 01:28:37PM -0700, Poyo VL wrote:
> When I tried to compile I got the following warning:
> fs/ocfs2/slot_map.c: In function ?ocfs2_init_slot_info?:
> fs/ocfs2/slot_map.c:360: warning: ?bytes? may be used uninitialized in this 
> function
> fs/ocfs2/slot_map.c:360: note: ?bytes? was declared here 
> Compiler: gcc version 4.4.3 (GCC) on Mandriva
> I'm not sure why this warning occurs, I think compiler don't know that variable 
> "bytes" is initialized when it is sent by reference to 
> ocfs2_slot_map_physical_size and it throws that ugly warning.
> However, a simple initialization of "bytes" variable with 0 will fix it.
> Patch is downer, I also attached it because there are problems with Yahoo! Mail.
> 
> Signed-off-by: Ionut Gabriel Popescu <poyo_vl@yahoo.com>

	This patch is now in the merge-window branch of ocfs2.git.  In
the future, please send patches inline without MIME.

Joel
-- 

"The lawgiver, of all beings, most owes the law allegiance.  He of all
 men should behave as though the law compelled him.  But it is the
 universal weakness of mankind that what we are given to administer we
 presently imagine we own."
        - H.G. Wells

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
