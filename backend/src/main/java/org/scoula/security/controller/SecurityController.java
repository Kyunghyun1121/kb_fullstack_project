package org.scoula.security.controller;

import java.util.Collection;
import lombok.extern.slf4j.Slf4j;
import org.scoula.security.account.domain.CustomUser;
import org.scoula.security.account.domain.MemberVO;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/*@Slf4j
@RequestMapping("/api/security")
@Controller
public class SecurityController {

  @GetMapping("/all")      // 모든 사용자 접근 가능
  public void doAll() {
    log.info("do all can access everybody");
  }

*//*  @GetMapping("/member")   // MEMBER 또는 ADMIN 권한 필요
  public void doMember() {
    log.info("logined member");
  }*//*


  @GetMapping("/member")
  public void doMember(Authentication authentication) {
    // Principal에서 UserDetails 추출
    UserDetails userDetails = (UserDetails) authentication.getPrincipal();

    String username = userDetails.getUsername();           // 사용자 ID
    Collection<? extends GrantedAuthority> authorities = userDetails.getAuthorities(); // 권한 목록

    log.info("사용자 ID: {}", username);
    log.info("권한 목록: {}", authorities);
  }


  @GetMapping("/admin")
  public void doAdmin(@AuthenticationPrincipal CustomUser customUser) {
    // CustomUser에서 MemberVO 정보 추출
    MemberVO member = customUser.getMember();

    log.info("사용자 정보: {}", member);
    log.info("사용자 이메일: {}", member.getEmail());
    log.info("등록일: {}", member.getRegDate());

    // 권한 정보도 접근 가능
    Collection<? extends GrantedAuthority> authorities = customUser.getAuthorities();
    log.info("보유 권한: {}", authorities);
  }


*//*  @GetMapping("/admin")    // ADMIN 권한만 접근 가능
  public void doAdmin() {
    log.info("admin only");
  }*//*

  @GetMapping("/login")    // 로그인 요청 매핑
  public void login() {
    log.info("login page");
  }

  @GetMapping("/logout")
  public void logout() {
    log.info("logout page");
  }

}*/


@Slf4j
@RequestMapping("/api/security")
@RestController
public class SecurityController {

  /**
   * 모든 사용자 접근 가능 (인증 불필요)
   */
  @GetMapping("/all") //  /api/security/all
  public ResponseEntity<String> doAll() {
    log.info("do all can access everybody");
    return ResponseEntity.ok("All can access everybody");
  }

  /**
   * ROLE_MEMBER 권한 필요
   */
  @GetMapping("/member") // /api/security/member
  public ResponseEntity<String> doMember(Authentication authentication) {
    UserDetails userDetails = (UserDetails) authentication.getPrincipal();
    log.info("username = " + userDetails.getUsername());
    return ResponseEntity.ok(userDetails.getUsername());
  }

  /**
   * ROLE_ADMIN 권한 필요
   */
  @GetMapping("/admin") //  /api/security/admin
  public ResponseEntity<MemberVO> doAdmin(
      @AuthenticationPrincipal CustomUser customUser
  ) {
    MemberVO member = customUser.getMember();
    log.info("username = " + member);
    return ResponseEntity.ok(member);
  }
}