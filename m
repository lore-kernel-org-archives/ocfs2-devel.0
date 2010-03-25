From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 25 Mar 2010 11:25:33 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Teach truncating and
 punching-hole codes to handle fastsymlink.
In-Reply-To: <4BA97745.8040009@oracle.com>
References: <1269331484-21262-1-git-send-email-tristan.ye@oracle.com>	<20100323195224.GA31783@mail.oracle.com>	<4BA96675.80506@oracle.com>	<20100324021306.GH31783@mail.oracle.com>
	<4BA97745.8040009@oracle.com>
Message-ID: <4BABAA9D.7080702@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

tristan wrote:
>>> Not exactly,
>>>
>>> Sunil reported such a bug from userspace in libocfs2, I suddenly 
>>> realised that we could also do the same in fs.
>>>       
>> 	

I did not see the patch for libocfs2? Is it in the pipeline or did
I miss it?
