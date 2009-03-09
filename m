From: Joel Becker <Joel.Becker@oracle.com>
Date: Sun, 8 Mar 2009 23:47:12 -0700
Subject: [Ocfs2-devel] [PATCH 0/2] ocfs2: two bug fixes about xattr
	and	inline-data
In-Reply-To: <49B4B8B8.7030108@oracle.com>
References: <49ADF2FB.6060503@oracle.com>
	<20090305023617.GA18729@mail.oracle.com>
	<1236572226.6816.30.camel@tristan-laptop.cn.oracle.com>
	<49B4A1B8.10806@oracle.com>
	<1236575084.6816.35.camel@tristan-laptop.cn.oracle.com>
	<49B4AC58.4090400@oracle.com>
	<1236579270.6816.39.camel@tristan-laptop.cn.oracle.com>
	<49B4B8B8.7030108@oracle.com>
Message-ID: <20090309064711.GB27610@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Mar 09, 2009 at 02:35:36PM +0800, Tiger Yang wrote:
> I found these two bugs in latest mainline kernel not other branch.

	The bugs should still be in cacheme - cacheme doesn't change
the inline data code.

Joel

-- 

"One of the symptoms of an approaching nervous breakdown is the
 belief that one's work is terribly important."
         - Bertrand Russell 

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
