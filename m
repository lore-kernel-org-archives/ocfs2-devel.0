From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Wed, 25 May 2016 10:34:59 +0800
Subject: [Ocfs2-devel] OCFS2 benchmark questions
In-Reply-To: <573F3B8C020000F900037F05@prv-mh.provo.novell.com>
References: <573F3B8C020000F900037F05@prv-mh.provo.novell.com>
Message-ID: <57450F53.70602@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 05/20/2016 04:30 PM, Gang He wrote:
> Hello Joseph, Junxiao and All,
> 
> I got some benchmark related questions, but due to hardware limitation in our local lab, we have not enough information to answer the questions. 
> Could you help to look at the questions, if you ever did the related testings in your sites.
> 1) How many nodes can OCFS2 cluster scale out to? theoretically, the answer is 32. but who ever did the testing with the maximum number of nodes? second, too many nodes will impact the performance, or not?
The limit is 255, but we didn't advise using more than 32 nodes. More
nodes impact performance for sure.

Thanks,
Junxiao.
> 
> 2) Who can help to share OCFS2 benchmark information/data in the physical environment? e.g. node hardware information, back-end storage information, IO read/write data, IOPS/IO throughput. etc.
> 
> 
> Thanks
> Gang  
> 
> 
