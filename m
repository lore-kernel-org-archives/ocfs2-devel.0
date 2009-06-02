From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 02 Jun 2009 11:34:14 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] OCFS2: timer to queue scan of all
 orphan slots
In-Reply-To: <4A256EDF.6080900@oracle.com>
References: <1243923105-3339-1-git-send-email-srinivas.eeda@oracle.com>	<1243923105-3339-2-git-send-email-srinivas.eeda@oracle.com>
	<4A256EDF.6080900@oracle.com>
Message-ID: <4A2570A6.4090800@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Sunil Mushran wrote:
>> +	u64  			ds_seqno;       /* incremented on every scan */ 
>>     
>
> $ echo $[4*1024*1024*1024/$[60*24*365]]
> 8171
> Even if we fire once every second, it will take us 8171 years to wrap 
> u32. ;)
>   

$ echo $[4*1024*1024*1024/$[60*60*24*365]]
136

duh... it's 136 years. But long enough, I think.
