From: tao.ma <tao.ma@oracle.com>
Date: Mon Nov 26 16:59:56 2007
Subject: [Ocfs2-devel] [PATCH 6/6] Add online resize in tunefs.ocfs2, take
	1
In-Reply-To: <474B50C6.7080904@tiscali.nl>
References: <20071116084804.GA3956@tma-pc1.cn.oracle.com>
	<474B50C6.7080904@tiscali.nl>
Message-ID: <474B6BBB.40401@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Roel Kluin wrote:
> Tao Ma wrote:
>   
>> +static errcode_t find_mount_point(char *device)
>> +{
>> +	int mount_flags = 0;
>> +	errcode_t ret;
>> +
>> +	memset(mnt_dir, 0, sizeof(mnt_dir));
>> +
>> +	ret = ocfs2_check_mount_point(device, &mount_flags,
>> +				      mnt_dir, sizeof(mnt_dir));
>> +	if (ret)
>> +		goto out;
>> +
>> +	if ((!mount_flags & OCFS2_MF_MOUNTED) ||
>>     
>
> if(!(mount_flags & OCFS2_MF_MOUNTED) ||
>   
Thanks for pointing it out.
>   
>> +	    (mount_flags & OCFS2_MF_READONLY) ||
>> +	    (mount_flags & OCFS2_MF_SWAP)) {
>> +		ret = OCFS2_ET_BAD_DEVICE_NAME;
>> +		goto out;
>> +	}
>> +
>> +	ret = 0;
>> +out:
>> +	return ret;
>> +}
>>     
