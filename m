From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 5 Mar 2009 15:32:01 -0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: tweak to get the maximum
	inline data size	with xattr
In-Reply-To: <1236222375-10467-1-git-send-email-tiger.yang@oracle.com>
References: <49AF40A9.8050601@oracle.com>
	<1236222375-10467-1-git-send-email-tiger.yang@oracle.com>
Message-ID: <20090305233201.GC27682@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Mar 05, 2009 at 11:06:15AM +0800, Tiger Yang wrote:
> Replace max_inline_data with max_inline_data_with_xattr
> to ensure it correct when xattr inlined.
> 
> Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
Acked-by: Joel Becker <joel.becker@oracle.com>

Probably want to make sure the same problem doesn't affect ocfs2-tools.

Joel

-- 

"If the human brain were so simple we could understand it, we would
 be so simple that we could not."
	- W. A. Clouston

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
