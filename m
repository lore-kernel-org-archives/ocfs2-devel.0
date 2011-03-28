From: Tiger Yang <tiger.yang@oracle.com>
Date: Mon, 28 Mar 2011 16:50:30 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: clean up mount option about
	atime in ocfs2.txt
In-Reply-To: <20110326214403.GB8837@noexit>
References: <4D6E2994.1050302@oracle.com>
	<1299065529-6626-1-git-send-email-tiger.yang@oracle.com>
	<20110326214403.GB8837@noexit>
Message-ID: <4D904BD6.3030104@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 03/27/2011 05:44 AM, Joel Becker wrote:
> On Wed, Mar 02, 2011 at 07:32:09PM +0800, Tiger Yang wrote:
>> -	if (osb->s_atime_quantum != OCFS2_DEFAULT_ATIME_QUANTUM)
>> +	if (!(mnt->mnt_flags&  MNT_NOATIME)&&  !(mnt->mnt_flags&  MNT_RELATIME))
>>   		seq_printf(s, ",atime_quantum=%u", osb->s_atime_quantum);
> 	I can see why you don't print in the case of noatime or
> relatime, but you should keep the check for DEFAULT_ATIME_QUANTUM.
> There's no point in printing it if it is the default.
Hi, Joel,
I have thought this issue, I choose to show the quantum value when user 
mount with strictatime, because we don't as "strict" as the other file 
system to update atime by default.  If we don't show the default quantum 
value, that may be confuse the new user to ocfs2.

Thanks,
tiger
