From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 29 Oct 2009 15:19:47 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: return f_fsid info in
 ocfs2_statfs(), v4
In-Reply-To: <49704641.1010005@suse.de>
References: <49704641.1010005@suse.de>
Message-ID: <20091029221946.GA3739@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jan 16, 2009 at 04:33:05PM +0800, Coly Li wrote:
> Currently f_fsid of struct kstatfs returned from ocfs2_statfs() is undefined (vfs layer fills 0 as
> default). Since in some conditions, f_fsid value might be used as (f_fsid, ino) pair to
> uniquely identify a file, ocfs2 should return a unique defined f_fsid value from ocfs2_statfs().
> 
> Because uuid_str is identified no mater on big or litlle endian machine, it's also endian consistent
> to use osb->uuid_str to generate f_fsid value.
> 
> Signed-off-by: Coly Li <coly.li@suse.de>
> Cc: Sunil Mushran <sunil.mushran@oracle.com>
> Cc: Mark Fasheh <mfasheh@suse.com>

	This patch is now in the fixes branch of ocfs2.git.

Joel

-- 

"The doctrine of human equality reposes on this: that there is no
 man really clever who has not found that he is stupid."
	- Gilbert K. Chesterson

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
