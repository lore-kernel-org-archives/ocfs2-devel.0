From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue Aug  3 13:40:25 2004
Subject: [Ocfs2-devel] Calculating volume size from superblock
In-Reply-To: <60C14C611F1DDD4198D53F2F43D8CA3B01864545@orsmsx410>
References: <60C14C611F1DDD4198D53F2F43D8CA3B01864545@orsmsx410>
Message-ID: <20040803183637.GK2595@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Aug 02, 2004 at 03:00:44PM -0700, Villalovos, John L wrote:
> Just wondering.  As a possible RFE.  Is there any reason the size of the
> global bitmap could not be in the superblock?  It seems strange that in
> order to find out how big the filesystem is I have to actually traverse
> the filesystem.

	Well, the global bitmap is what the global bitmap represents, if
you'll allow circular logic.  Why should the superblock need to be
updated if global bitmap information changes?  This actually matters in
a cluster.

Joel

-- 

"Depend on the rabbit's foot if you will, but remember, it didn't
 help the rabbit."
	- R. E. Shay

Joel Becker
Senior Member of Technical Staff
Oracle Corporation
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
