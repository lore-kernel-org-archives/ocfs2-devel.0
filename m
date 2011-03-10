From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 09 Mar 2011 18:27:52 -0800
Subject: [Ocfs2-devel] [PATCH] Ocfs2: do not allow fallocate on dir file
In-Reply-To: <20110309230132.GF1703@wotan.suse.de>
References: <201103041510.33128.lidongyang@novell.com>
	<20110309230132.GF1703@wotan.suse.de>
Message-ID: <4D783728.3070307@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 03/09/2011 03:01 PM, Mark Fasheh wrote:
> On Fri, Mar 04, 2011 at 03:10:33PM +0800, Li Dongyang wrote:
>> @@ -1870,6 +1870,11 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
>>   		goto out_inode_unlock;
>>   	}
>>
>> +	if (!S_ISREG(inode->i_mode)) {
>> +		ret = -EINVAL;
>> +		goto out_inode_unlock;
>> +	}
> You might want to move the check into ocfs2_fallocate to mirror what
> ocfs2_change_file_space() does. Otherwise, looks like a good catch.
>

Tristan pointed out that this check was already in ocfs2_change_file_space().
So this patch should not be required. Am I missing something?
