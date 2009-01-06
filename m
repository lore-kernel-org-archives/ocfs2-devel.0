From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 06 Jan 2009 15:54:52 -0800
Subject: [Ocfs2-devel] [PATCH 2/2] features: Make inline-data a default
 feature
In-Reply-To: <49581AF4.5020501@oracle.com>
References: <1230330267-1975-1-git-send-email-mfasheh@suse.com>	<1230330267-1975-2-git-send-email-mfasheh@suse.com>	<20081226222824.GD17410@wotan.suse.de>
	<49581AF4.5020501@oracle.com>
Message-ID: <4963EF4C.3070108@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

aah... sob.

Tao Ma wrote:
> Signed-off-by: Tao Ma <tao.ma@oracle.com>
>
> Mark Fasheh wrote:
>   
>> On Fri, Dec 26, 2008 at 02:24:27PM -0800, Mark Fasheh wrote:
>>     
>>> Kernels since 2.6.24 have supported this, I think it's time to make it a
>>> default feature.
>>>
>>> Signed-off-by: Mark Fasheh <mfasheh@suse.com>
>>>       
>> Whoops, forgot to add inline-data to the list of default features in the
>> mkfs.ocfs2 man page... Updated patch attached.
>> 	--Mark
>>
>> From: Mark Fasheh <mfasheh@suse.com>
>>
>> [PATCH 2/2] features: Make inline-data a default feature
>>
>> Kernels since 2.6.24 have supported this, I think it's time to make it a
>> default feature.
>>
>> Signed-off-by: Mark Fasheh <mfasheh@suse.com>
>> ---
>>  libocfs2/feature_string.c  |    3 ++-
>>  mkfs.ocfs2/mkfs.ocfs2.8.in |    2 +-
>>  2 files changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/libocfs2/feature_string.c b/libocfs2/feature_string.c
>> index 7b1f93e..e6633da 100644
>> --- a/libocfs2/feature_string.c
>> +++ b/libocfs2/feature_string.c
>> @@ -62,7 +62,8 @@ static struct feature_level_translation ocfs2_feature_levels_table[] = {
>>  
>>  static ocfs2_fs_options feature_level_defaults[] = {
>>  	{OCFS2_FEATURE_COMPAT_BACKUP_SB | OCFS2_FEATURE_COMPAT_JBD2_SB,
>> -	 OCFS2_FEATURE_INCOMPAT_SPARSE_ALLOC,
>> +	 OCFS2_FEATURE_INCOMPAT_SPARSE_ALLOC |
>> +	 OCFS2_FEATURE_INCOMPAT_INLINE_DATA,
>>  	 OCFS2_FEATURE_RO_COMPAT_UNWRITTEN},  /* OCFS2_FEATURE_LEVEL_DEFAULT */
>>  
>>  	{OCFS2_FEATURE_COMPAT_BACKUP_SB | OCFS2_FEATURE_COMPAT_JBD2_SB,
>> diff --git a/mkfs.ocfs2/mkfs.ocfs2.8.in b/mkfs.ocfs2/mkfs.ocfs2.8.in
>> index 8b5dbed..a89a4d8 100644
>> --- a/mkfs.ocfs2/mkfs.ocfs2.8.in
>> +++ b/mkfs.ocfs2/mkfs.ocfs2.8.in
>> @@ -153,7 +153,7 @@ Chooses fewer features but ensures that the file system can be mounted from olde
>>  .RS 1.2i
>>  .TP
>>  \fBdefault\fR
>> -The default feature set tries to strike a balance between providing new features and maintaining compatibility with relatively recent versions of \fIOCFS2\fR. It currently enables \fBsparse\fR and \fBunwritten\fR.
>> +The default feature set tries to strike a balance between providing new features and maintaining compatibility with relatively recent versions of \fIOCFS2\fR. It currently enables \fBsparse\fR, \fBunwritten\fR and \fBinline-data\fR.
>>  .RE
>>  .RS 1.2i
>>  .TP
>>     
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>   
