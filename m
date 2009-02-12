From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 12 Feb 2009 11:55:30 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: add IO error check in
 ocfs2_get_sector() -v2
In-Reply-To: <20090212194626.GC14638@ca-server1.us.oracle.com>
References: <200902120748.n1C7mVqx020705@acsinet13.oracle.com>
	<4994773E.6020609@oracle.com>
	<20090212194626.GC14638@ca-server1.us.oracle.com>
Message-ID: <49947EB2.5090503@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I am looking at the brelse() in ocfs2_fill_super().

Joel Becker wrote:
> On Thu, Feb 12, 2009 at 11:23:42AM -0800, Sunil Mushran wrote:
>   
>> The matching brelse() is in ocfs2_fill_super(). So you shouldn't
>> need it. Cross check though please.
>>     
>
> 	No, if we get an error from ocfs2_get_sector() we return without
> brelse().  So the patch is correct.
>
> Joel
>
>   
