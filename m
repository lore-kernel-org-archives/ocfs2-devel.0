From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Mar 16 18:35:15 2004
Subject: [Ocfs2-devel] [PATCH]2.6 mechanism for holding private inode data
In-Reply-To: <20040315221654.GD20057@ca-server1.us.oracle.com>
References: <200403110449.i2B4ncDw032388@penguin.co.intel.com>
	<20040311215300.GA7623@penguin.co.intel.com>
	<20040312204747.GA20057@ca-server1.us.oracle.com>
	<20040312210701.GA12754@penguin.co.intel.com>
	<20040313000913.GB20057@ca-server1.us.oracle.com>
	<20040314223440.GA1408@penguin.co.intel.com>
	<20040315221654.GD20057@ca-server1.us.oracle.com>
Message-ID: <20040317003510.GF20057@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Alright, things look good for this patch -- I've committed it to SVN.
I'll prolly change the generic_ip to an ocfs_inode * later.
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
