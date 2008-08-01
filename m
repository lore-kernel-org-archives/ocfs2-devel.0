From: Coly Li <coyli@suse.de>
Date: Fri, 01 Aug 2008 09:29:34 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2-tools: add error message to
 mount.ocfs2 when mount point is invalid.
In-Reply-To: <20080731200056.GC14766@mail.oracle.com>
References: <4891C0C5.1010007@suse.de> <20080731200056.GC14766@mail.oracle.com>
Message-ID: <489266FE.2080501@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Joel Becker Wrote:
> On Thu, Jul 31, 2008 at 09:40:21PM +0800, Coly Li wrote:
>> diff --git a/mount.ocfs2/mount.ocfs2.c b/mount.ocfs2/mount.ocfs2.c
>> index a97b4cb..eb8e336 100644
>> --- a/mount.ocfs2/mount.ocfs2.c
>> +++ b/mount.ocfs2/mount.ocfs2.c
>> @@ -382,9 +382,21 @@ int main(int argc, char **argv)
>>   			o2cb_complete_group_join(&cluster, &desc, errno);
>>   		}
>>   		block_signals (SIG_UNBLOCK);
>> -		com_err(progname, ret, "while mounting %s on %s. "
>> -			"Check 'dmesg' for more information on this error.",
>> -			mo.dev, mo.dir);
>> +
>> +		/* complain mount failure */
>> +		if (lstat(mo.dir, &statbuf))
>> +			com_err(progname, 0, "mount point %s does not "
>> +				"exist", mo.dir);
>> +		else if (stat(mo.dir, &statbuf))
>> +			com_err(progname, 0, "mount point %s is a "
>> +				"symbolic link to nowhere", mo.dir);
>> +		else if (stat(mo.dir, &statbuf) || !S_ISDIR(statbuf.st_mode))
>   +		else if (!S_ISDIR(statbuf.st_mode))
> 
> 	You successfully called stat in the previous "else if" clause.
wow, thanks for catching this :)

> 
>> +			com_err(progname, 0, "mount point %s is not "
>> +				"a directory", mo.dir);
>> +		else
>> +			com_err(progname, ret, "while mounting %s on %s. "
>> +				"Check 'dmesg' for more information on this "
>> +				"error.", mo.dev, mo.dir);
> 
> 	Also, I agree with sunil's "broken symbolic link" text.
patch modified and resend to ocfs2-tools-devel again.

-- 
Coly Li
SuSE PRC Labs
