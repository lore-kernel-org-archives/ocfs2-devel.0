From: Coly Li <coly.li@suse.de>
Date: Fri, 08 May 2009 15:57:20 +0800
Subject: [Ocfs2-devel] question of dentry number
In-Reply-To: <20090508073827.GA14278@ca-server1.us.oracle.com>
References: <4A03DF23.8090903@suse.de>
	<20090508073827.GA14278@ca-server1.us.oracle.com>
Message-ID: <4A03E5E0.3070806@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Joel Becker Wrote:
> On Fri, May 08, 2009 at 03:28:35PM +0800, Coly Li wrote:
>> then run this script on ocfs2 volume of both nodes for 10 seconds, ls -al:
>> total 32
>> drwxr-xr-x 2 root root      4096 2009-05-08 15:34 .
>> drwxr-xr-x 4 root root      4096 2009-05-08 15:29 ..
>> -rw-r--r-- 1 root root 939787135 2009-05-08 15:34 file0000000000
>> -rw-r--r-- 1 root root 922127231 2009-05-08 15:34 file0000000001
>> -rw-r--r-- 1 root root         0 2009-05-08 15:34 file0000000002
>> -rw-r--r-- 1 root root 503703844 2009-05-08 15:34 file0000000003
>>
>> I don't understand how there are 32 dentries in the directory. Can anybody tell
>> me the magic ? Or it's a bug.
>>
> 
> 	total is the number of directory blocks.
> 
mixed with link reference number, brain short dot...

-- 
Coly Li
SuSE Labs
