From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 31 Mar 2010 20:38:39 -0700
Subject: [Ocfs2-devel] [PATCH 13/15] ocfs2: ocfs2_group_bitmap_size has
 to handle old volume.
In-Reply-To: <1270090752-18935-13-git-send-email-tao.ma@oracle.com>
References: <4BB40AB4.8040205@oracle.com>
	<1270090752-18935-13-git-send-email-tao.ma@oracle.com>
Message-ID: <20100401033838.GJ28680@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Apr 01, 2010 at 10:59:10AM +0800, Tao Ma wrote:
> ocfs2_group_bitmap_size has to handle the case when the
> volume don't have discontiguous block group support.

	NAK.  We specify 256 in all cases.  This doesn't hurt old code
because we've never used more bits.  Even though our old bg_size values
were much larger, we never used that space because bg_bits was set to
the smaller value.

Joel

-- 

"Get right to the heart of matters.
 It's the heart that matters more."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
