Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D35E9C05027
	for <ocfs2-devel@archiver.kernel.org>; Mon, 20 Feb 2023 12:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=POHE8BkS27Rbuu3/02M3PG10jrptkSA7EbEObdehpIg=;
 b=MK+W8XlNpsHHpzZdcFpo8OHtDlNtx9bfWnore796E4yUU7c1ooxdMM1LnPma5tes0fCFNE7CtVVm
   CQu+ztPgh3rDn1rxorMOEriJ/YcY5TxJdLu59d6eW8Rqe+jVdFKTIr2D6NtSau/XMIKfMiX0MxdY
   XkiRL1QizZIHyh7pn2GIPIIW7qi/ercApoU9eY0qtS7eCdE16YBDc1nV6EH8GKobaVZXa2gRhY7E
   d2OwvjRFsNQBD4VMqyPn2FLlmackt7xpwuvJPvVSrv93lAmURLlrS6/HF+fk5Sj87+wV3oNFgFHN
   Vjq9iM5mmecppzYyFL7O56baVDGijfsgQjVjfA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=POHE8BkS27Rbuu3/02M3PG10jrptkSA7EbEObdehpIg=;
 b=mi7d5//iEKa/QG2rr21RQ/6pJJtPN7fsei8oe1uSLzQZDbQB7fQlMkVfKMu5zlRmFObzCBwCvXgQ
   6MzVnfvdsOCwApeQLh/ob8RfJBBBEAueC8SLfHkb/SC6S6VBDdBmDdzPWyNZOPaVviRSJP9X6Il/
   csHu/v8kJVWM0e/8waikj1wT3Vq7oV+x36q30zoz2cMzxZaAJX65Bf+CBp5D6/+WVqSs3iIKifmy
   6OjEYflkvwqWM312ApjolD4eNVoTEDRQhcqXz5EvGGS/2lFEXF6uYCoeD/qKWPz5XJvymSlfnt7M
   ac4TgOfgX8/5NFDzTlKggoXxzvfNjQrbm8Bj3Q==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230206 64bit (built Feb  6
 2023))
 with ESMTPS id <0RQD00NW4Q21BTC0@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 20 Feb 2023 12:44:26 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id :
 subject : from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=RjFiIL2vWgM7tyrPIzie4SN6UpJPtmIUWHUc+QpTxjc=;
 b=pc7eJe6H4AvhAHMxn++6uGWF1g7J+9JXzTOhLh8tpEXZCg3xL9Et43K6QhpMtShldcg0
 VWlfCjbGzxtdCpe+5Hbxz+tmk2gqQHRw6Mp3L45SISfSb9z5b0hhJ0+wCPIrozNC1xoo
 e7GOCKAAeV2GQ182WX57HHKFZcnCB+xK9vdvslbyflieZYUpxUcKwMnjEnKxTcspIetN
 vHSJoR+fgF3F+VMaMv90Dn3jofybEF28li3MwKDvZOfaqDisw6GiCNLALZBU2zm7uIi7
 C43zBNiZpksGSYZ7Rdb8S1UglV2FzuTg1m6MQ4zLTRVCFH3Wy1lXwJyVu1aCkIbCqaeI +w==
Message-id: <22f48112c2fbc2812317c33af13accb022e9abdf.camel@linux.ibm.com>
To: Roberto Sassu <roberto.sassu@huaweicloud.com>, mark@fasheh.com,
 jlbec@evilplan.org, joseph.qi@linux.alibaba.com, dmitry.kasatkin@gmail.com,
 paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
 stephen.smalley.work@gmail.com, eparis@parisplace.org, casey@schaufler-ca.com
Date: Mon, 20 Feb 2023 07:43:24 -0500
In-reply-to: <20221201104125.919483-5-roberto.sassu@huaweicloud.com>
References: <20221201104125.919483-1-roberto.sassu@huaweicloud.com>
 <20221201104125.919483-5-roberto.sassu@huaweicloud.com>
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8)
MIME-version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-20_09,2023-02-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 phishscore=0 clxscore=1015 mlxscore=0
 malwarescore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=741 impostorscore=0
 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302200109
X-Source-IP: 148.163.156.1
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10626
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 impostorscore=0 clxscore=132
 mlxlogscore=675 adultscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 priorityscore=237 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302200115
Cc: nicolas.bouchinet@clip-os.org, keescook@chromium.org,
 selinux@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
 reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v7 4/6] security: Allow all LSMs to provide
 xattrs for inode_init_security hook
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: Mimi Zohar via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Mimi Zohar <zohar@linux.ibm.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-TM-AS-GCONF: 00
X-ServerName: mx0a-001b2d01.pphosted.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:148.163.158.5 ip4:148.163.156.1 ~all
X-Spam: Clean
X-Proofpoint-GUID: Bf-r0axlaP3zGg_sJrOEH9LJG9oQbYqF
X-Proofpoint-ORIG-GUID: Bf-r0axlaP3zGg_sJrOEH9LJG9oQbYqF
Reporting-Meta:
 AAG/yFG0LojD46iChGrNN9oqAPIYUHjeKugu0MFuGHyUeX6ep1hAPL3yE5puiLex
 GYjpLRC8y6j/Q6Hr7lwj+K7ECRrpptiVYAkEeatI0d4PY1FKdvm4Y7fnr/J4NnyU
 9sHpoIAuaCo+yv9jXZ02afZwWd/HWgn3knfAS753ZNsZvCEFIDxg7J0aGPscvsWv
 7LAFPhjQ1hI3iuTaFnbteMiw6FX8jwLqniUhPsVHijNR4vUrZaE0XZtix9Wxa49y
 0LF2+0/zxGe5u6gf+4vMRRXpXDrsFgyVjHqgyNsyB68xNc1iDjc+U/23veDDnSub
 op1gScoByw6ZqFhEJqabmKFnGKMEZqkuB3PcrfRsZja+WCcfgL0jq8eDYjMfI9Md
 OEBPSQdQBQTGKGDM7vQyIttiSUggpNOzxGFSTpf0va/coPYHDjI/8rbZwK7ylgIj
 WktzLURUJlWS0SVs0zGNe7B1eWFdpQi/C9uSk5sld3v6ecLegUo23tRN8TTLxVsl
 L2l9J1mP4VBcuM4MVIMxHQY/CRwRAZDH8WPcNfvEE11n

On Thu, 2022-12-01 at 11:41 +0100, Roberto Sassu wrote:
> From: Roberto Sassu <roberto.sassu@huawei.com>
> 
> Currently, security_inode_init_security() supports only one LSM providing
> an xattr and EVM calculating the HMAC on that xattr, plus other inode
> metadata.
> 
> Allow all LSMs to provide one or multiple xattrs, by extending the security
> blob reservation mechanism. Introduce the new lbs_xattr field of the
> lsm_blob_sizes structure, so that each LSM can specify how many xattrs it
> needs, and the LSM infrastructure knows how many xattr slots it should
> allocate.
> 
> Dynamically allocate the xattrs array to be populated by LSMs with the
> inode_init_security hook, and pass it to the latter instead of the
> name/value/len triple. Update the documentation accordingly, and fix the
> description of the xattr name, as it is not allocated anymore.
> 
> Since the LSM infrastructure, at initialization time, updates the number of
> the requested xattrs provided by each LSM with a corresponding offset in
> the security blob (in this case the xattr array), it makes straightforward
> for an LSM to access the right position in the xattr array.
> 
> There is still the issue that an LSM might not fill the xattr, even if it
> requests it (legitimate case, for example it might have been loaded but not
> initialized with a policy). Since users of the xattr array (e.g. the
> initxattrs() callbacks) detect the end of the xattr array by checking if
> the xattr name is NULL, not filling an xattr would cause those users to
> stop scanning xattrs prematurely.
> 
> Solve that issue by introducing security_check_compact_filled_xattrs(),
> which does a basic check of the xattr array (if the xattr name is filled,
> the xattr value should be too, and viceversa), and compacts the xattr array
> by removing the holes.
> 
> An alternative solution would be to let users of the xattr array know the
> number of elements of that array, so that they don't have to check the
> termination. However, this seems more invasive, compared to a simple move
> of few array elements.
> 
> security_check_compact_filled_xattrs() also determines how many xattrs in
> the xattr array have been filled. If there is none, skip
> evm_inode_init_security() and initxattrs(). Skipping the former also avoids
> EVM to crash the kernel, as it is expecting a filled xattr.
> 
> Finally, adapt both SELinux and Smack to use the new definition of the
> inode_init_security hook, and to correctly fill the designated slots in the
> xattr array. For Smack, reserve space for the other defined xattrs although
> they are not set yet in smack_inode_init_security().
> 
> Reported-by: Nicolas Bouchinet <nicolas.bouchinet@clip-os.org> (EVM crash)
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> Reviewed-by: Casey Schaufler <casey@schaufler-ca.com>

Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
