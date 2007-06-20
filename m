From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Jun 20 17:21:20 2007
Subject: [Ocfs2-devel] Re: [PATCH] zero_user_page conversion
In-Reply-To: <4679A558.1010107@redhat.com>
References: <4679A558.1010107@redhat.com>
Message-ID: <20070621002116.GB17713@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Sandeen <sandeen@redhat.com>
Cc: cluster-devel@redhat.com, ext4 development <linux-ext4@vger.kernel.org>, samba-technical@lists.samba.org, linux-kernel Mailing List <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com

On Wed, Jun 20, 2007 at 05:08:24PM -0500, Eric Sandeen wrote:
> Use zero_user_page() in cifs, ocfs2, ext4, and gfs2 where possible.

Ok, the ocfs2 bits looked fine so I folded that part of the patch into
ocfs2.git, thanks.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
