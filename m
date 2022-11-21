Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CE80C433FE
	for <ocfs2-devel@archiver.kernel.org>; Mon, 21 Nov 2022 20:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=0Yz4VwgSED7C59/D0PjxHvp+eoWo7XInT+5FlyZUhNs=;
 b=IjT3g3E9SLynLApZZ3WN1EfJBJwamg5/5t5k/cmnqdZGwwgGjD1/yjl/9vwuIxNbL3Goh2gwm9iZ
   F6rSzupNunWahjMz/JrPKJizgO6i36dJTz5wTqKCEeQFzrHb6sqmYrVPHA/TYLvANroRw0U03l+t
   gnKoNgtXo5PWHkWCne95JRb7N0U/0fak0bUzaglbNHChhi1eaNN1oUlUZTwKesS3jhZ3gfaX7s8+
   +TcQcMPswaC+jl2GnUkKZaaGMKpiaNhwu/OAK5PazlCQ7uhdh92kDxgUt6ubtKRenAUrNeySXf8b
   JpJuOmoUjMBo5wzv9H/rRxRMmVJxbCTAsBzenA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=0Yz4VwgSED7C59/D0PjxHvp+eoWo7XInT+5FlyZUhNs=;
 b=b9W7IB6OObqWahPGgbAnM9ycuv0ijDpeKJksKWHxS06J6A9JFHhkEx+R1E6M/ZBO796eGAaahBmg
   WrcZrAla9L2eyKM1mLXIUH5ihce5vzO2HXAVWXN7KOI0fGaXDfZjktXW4uvValtJIBbF0QktxXRh
   fCCDaqbMeJq+CgKJ5KeehI2rynkooM/8AnD93aCr2fS3SFchYeeEVy+nfb2yFX7CMgGTiz1OkOOu
   6Dg/ikM1UecX1LtvcGZBEwmA/2qvS/Nv8U+GRueCxwN60tLsJ4jJVnSRdwegk+8Lza9fz3F2kVmH
   srHimV4ecTJMsCmOn3SjkFjJkxJBeGPvvS1Kog==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLP004N4U3W3RD0@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 21 Nov 2022 20:55:08 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id :
 subject : from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=7zCKX/4UjpQvenyrT8VZruRvalqRXYR6+icK2FwSEa4=;
 b=fjtgG3U2n53yDeBNWAZuAm3PDp2cFZ4R3+ps1ia+cUwJML1awN2FqbGANmzxLw3UJMYq
 Uu8+aG2GzpO8uIT0Z23sckf4UdI5xjyiqqRNgUTHRoe87JtPlu98IBi8JYfApYlSn2xi
 HpU8qBbTjKzIKFPZ9BY0rcnuAJloMtpYNnMm26B2pcgaQhMmzPvjty9uW+2L5BrRfvLQ
 gn5DTw7tKzTELyz8KJVaqGj1LZvCyv26ozGzuZmwB/tOniflRgcwcpYILFgyNjQ5uLc4
 0Et/aqTPAImeHW36i2Dut7UhGX0ppme5Vy7GGLwBjyKmYa5IvciD2rLbP14Hbfjvmg1y UA==
Message-id: <7812899531b2bd936b25fde8fc2f1c2a6080b2bd.camel@linux.ibm.com>
To: Roberto Sassu <roberto.sassu@huaweicloud.com>, dmitry.kasatkin@gmail.com,
 paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
 stephen.smalley.work@gmail.com, eparis@parisplace.org, casey@schaufler-ca.com
Date: Mon, 21 Nov 2022 15:54:19 -0500
In-reply-to: <aa5fa8c5f231115c58012352124df57d16a01e41.camel@huaweicloud.com>
References: <20221110094639.3086409-1-roberto.sassu@huaweicloud.com>
 <20221110094639.3086409-3-roberto.sassu@huaweicloud.com>
 <3dc4f389ead98972cb7d09ef285a0065decb0ad0.camel@linux.ibm.com>
 <aa5fa8c5f231115c58012352124df57d16a01e41.camel@huaweicloud.com>
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8)
MIME-version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_16,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 mlxscore=0 clxscore=1015 malwarescore=0 impostorscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 adultscore=0 bulkscore=0
 priorityscore=1501 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2211210155
X-Source-IP: 148.163.158.5
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10538
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=999
 impostorscore=0 suspectscore=0 priorityscore=192 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 adultscore=0 clxscore=134 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211210158 domainage_hfrom=13396
Cc: nicolas.bouchinet@clip-os.org, keescook@chromium.org,
 selinux@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
 linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v4 2/5] security: Rewrite
 security_old_inode_init_security()
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
X-ServerName: mx0b-001b2d01.pphosted.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:148.163.158.5 ip4:148.163.156.1 ~all
X-Spam: Clean
X-Proofpoint-GUID: vHsvuJjXvCNUIQfffnZwfFUz5ew5cRq1
X-Proofpoint-ORIG-GUID: vHsvuJjXvCNUIQfffnZwfFUz5ew5cRq1
Reporting-Meta:
 AAEqwA8dxAi7huh6L8H+KzX854kx030Nc8p7zoBpxsnQdmwU7jor24F8it1RZZ4g
 3sg9F/jVNrIIuiUP2D80zLxIbb9TtnDRjiAixLbUZ+idHYK+dXX65r/jUMrdFeys
 hTWu4sWbydLEAfTe2C1RsbhOB6dAlMrw0E6pqxsdav3V4SdI0yDohK22jciAKZ5U
 JI07XnNJYla/6SAlL2KXoLAldiN6m3QUNCBi0Ru66veRBIQKUahJcGSr0aUlNx5g
 gB7FXV/27exVh2BGWEVDFIgXJApXaGBQlhZKQVUHKl9EiaWuDErz80eFd+ikbswS
 v4aVDWyr4UqzleeVq24OjacsgaK19chbn7eSC+J9Z6x7+ZuI4veTxOvrlcpa4noK
 r2MgS4RgBgZjlW+ApKs2MFV6bURZSgcvawgMFJBLO6E7Gia2P0yaHM2YwMCVURON
 yEgjcrfZj+2qtSb0dl1I+ObXXe4pDn/JTHuG1T0fofSmKvPTi099X83fuJDQECXD
 uQRERcV1FvOOppnqJdIdQK97ZryxL+f4uoQQgPrcpxOF3A==

On Mon, 2022-11-21 at 10:45 +0100, Roberto Sassu wrote:
> > As ocfs2 already defines initxattrs, that leaves only reiserfs missing
> > initxattrs().  A better, cleaner solution would be to define one.
> 
> If I understood why security_old_inode_init_security() is called
> instead of security_inode_init_security(), the reason seems that the
> filesystem code uses the length of the obtained xattr to make some
> calculations (e.g. reserve space). The xattr is written at a later
> time.
> 
> Since for reiserfs there is a plan to deprecate it, it probably
> wouldn't be worth to support the creation of multiple xattrs. I would
> define a callback to take the first xattr and make a copy, so that
> calling security_inode_init_security() + reiserfs_initxattrs() is
> equivalent to calling security_old_inode_init_security().
> 
> But then, this is what anyway I was doing with the
> security_initxattrs() callback, for all callers of security_old_inode_i
> nit_security().
> 
> Also, security_old_inode_init_security() is exported to kernel modules.
> Maybe, it is used somewhere. So, unless we plan to remove it
> completely, it should be probably be fixed to avoid multiple LSMs
> successfully setting an xattr, and losing the memory of all except the
> last (which this patch fixes by calling security_inode_init_security())
> .
> 
> If there is still the preference, I will implement the reiserfs
> callback and make a fix for security_old_inode_init_security().

There's no sense in doing both, as the purpose of defining a reiserfs
initxattrs function was to clean up this code making it more readable.

Mimi



_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
