From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 2 Dec 2009 17:38:50 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: return -EAGAIN instead of
	EAGAIN in dlm
In-Reply-To: <1258597066-9227-1-git-send-email-tiger.yang@oracle.com>
References: <4B0474A7.9020506@oracle.com>
	<1258597066-9227-1-git-send-email-tiger.yang@oracle.com>
Message-ID: <20091203013850.GF31647@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Nov 19, 2009 at 10:17:46AM +0800, Tiger Yang wrote:
> We used to return positive EAGAIN to indicate a retry action
> is needed in dlm_begin_reco_handler(). Now we return negative
> -EAGAIN to erase the confusion caused by this error code.
> 
> Signed-off-by: Tiger Yang <tiger.yang@oracle.com>

	This is now in the 'merge-window' branch of ocfs2.git.

Joel

-- 

"I always thought the hardest questions were those I could not answer.
 Now I know they are the ones I can never ask."
			- Charlie Watkins

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
