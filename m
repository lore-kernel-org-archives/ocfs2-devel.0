From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 31 Mar 2010 17:52:32 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: be within spinlock when checking
 the owner of a lockres
In-Reply-To: <201003241442.o2NAdfs4028087@acsinet15.oracle.com>
References: <201003241442.o2NAdfs4028087@acsinet15.oracle.com>
Message-ID: <20100401005231.GE28680@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Mar 24, 2010 at 10:40:44PM +0800, Wengang Wang wrote:
> The checking of lockres owner in dlm_update_lvb() is not with spinlock
> protection. I don't see problem in current call path of dlm_update_lvb().
> But just for code robustness.
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>

	This patch is now in the fixes branch of ocfs2.git.

Joel

-- 

"You must remember this:
 A kiss is just a kiss,
 A sigh is just a sigh.
 The fundamental rules apply
 As time goes by."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
